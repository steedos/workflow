JsonRoutes.add 'post', '/api/workflow/retrieve', (req, res, next) ->
	try
		current_user_info = uuflowManager.check_authorization(req)
		current_user = current_user_info._id

		hashData = req.body
		_.each hashData['Instances'], (instance_from_client) ->
			instance = uuflowManager.getInstance(instance_from_client["_id"])
			retrieve_comment = instance_from_client['retrieve_comment']

			# 验证instance为审核中状态
			uuflowManager.isInstancePending(instance)
			# 校验申请单是当前用户已审核过的单子或者当前用户是提交人或申请人
			if (not instance.outbox_users.includes(current_user)) and (instance.submitter isnt current_user and instance.applicant isnt current_user)
				throw new Meteor.Error('error', '当前用户不符合取回条件')

			traces = instance.traces

			#获取最新的trace， 即取回步骤
			last_trace = _.find(traces, (t)->
				return t.is_finished is false
			)
			last_trace_id = last_trace._id
			previous_trace_id = last_trace.previous_trace_ids[0];
			previous_trace = _.find(traces, (t)->
				return t._id is previous_trace_id
			)
			previous_trace_step_id = previous_trace.step
			# 校验取回步骤的前一个步骤approve唯一并且处理人是当前用户
			previous_trace_approves = previous_trace.approves
			if previous_trace_approves.length isnt 1
				throw new Meteor.Error('error', '当前用户不符合取回条件')
			if previous_trace_approves[0].user isnt current_user
				throw new Meteor.Error('error', '当前用户不符合取回条件')

			# 获取一个flow
			flow = uuflowManager.getFlow(instance.flow)
			previous_step = uuflowManager.getStep(instance, flow, previous_trace_step_id)
			space_id = instance.space
			instance_id = instance._id
			old_inbox_users = instance.inbox_users
			setObj = new Object
			now = new Date
			_.each traces, (t)->
				if t._id is last_trace_id
					# 更新当前trace.approve记录
					_.each t.approves, (appr)->
						appr.start_date = now
						appr.finish_date = now
						appr.read_date = now
						appr.is_error = false
						appr.is_read = true
						appr.is_finished = true
						appr.finish_date = now
						appr.judge = ""
					# 在同一trace下插入取回操作者的approve记录
					current_space_user = uuflowManager.getSpaceUser(space_id, current_user)
					current_user_organization = db.organizations.findOne(current_space_user.organization)
					retrieve_appr = new Object
					retrieve_appr._id = new Mongo.ObjectID()._str
					retrieve_appr.instance = instance_id
					retrieve_appr.trace = t._id
					retrieve_appr.is_finished = true
					retrieve_appr.user = current_user
					retrieve_appr.user_name = current_user_info.name
					retrieve_appr.handler = current_user
					retrieve_appr.handler_name = current_user_info.name
					retrieve_appr.handler_organization = current_space_user.organization
					retrieve_appr.handler_organization_name = current_user_organization.name
					retrieve_appr.handler_organization_fullname = current_user_organization.fullname
					retrieve_appr.start_date = now
					retrieve_appr.finish_date = now
					retrieve_appr.due_date = t.due_date
					retrieve_appr.read_date = now
					retrieve_appr.judge = "retrieved"
					retrieve_appr.is_read = true
					retrieve_appr.description = retrieve_comment
					retrieve_appr.is_error = false
					retrieve_appr.values = new Object
					t.approves.push(retrieve_appr)

					# 更新当前trace记录
					t.is_finished = true
					t.finish_date = now
					t.judge = "retrieved"

			# 插入下一步trace记录
			newTrace = new Object
			newTrace._id = new Mongo.ObjectID()._str
			newTrace.instance = instance_id
			newTrace.previous_trace_ids = [last_trace_id]
			newTrace.is_finished = false
			newTrace.step = previous_trace_step_id
			newTrace.start_date = now
			if previous_step.timeout_hours
				due_time = new Date().getTime() + (1000 * 60 * 60 * previous_step.timeout_hours)
				newTrace.due_date = new Date(due_time)
			newTrace.approves = []
			# 插入下一步trace.approve记录
			newApprove = new Object
			newApprove._id = new Mongo.ObjectID()._str
			newApprove.instance = instance_id
			newApprove.trace = newTrace._id
			newApprove.is_finished = false
			newApprove.user = current_user

			handler_info = db.users.findOne(current_user)
			newApprove.user_name = handler_info.name
			newApprove.handler = current_user
			newApprove.handler_name = handler_info.name

			space_user = uuflowManager.getSpaceUser(space_id, current_user)
			# 获取next_step_user所在的部门信息
			org_info = uuflowManager.getSpaceUserOrgInfo(space_user)
			newApprove.handler_organization = org_info["organization"]
			newApprove.handler_organization_name = org_info["organization_name"]
			newApprove.handler_organization_fullname = org_info["organization_fullname"]

			newApprove.start_date = now
			newApprove.is_read = false
			newApprove.is_error = false
			newApprove.values = new Object

			newTrace.approves.push(newApprove)
			setObj.inbox_users = [current_user]

			setObj.modified = now
			setObj.modified_by = current_user
			traces.push(newTrace)
			setObj.traces = traces

			r = db.instances.update({_id: instance_id}, {$set: setObj})
			if r
				# 给被删除的inbox_users 和 当前用户 发送push
				pushManager.send_message_current_user(current_user_info)
				_.each(old_inbox_users, (user_id)->
					if user_id isnt current_user
						pushManager.send_message_to_specifyUser("current_user", user_id)
				)

		JsonRoutes.sendResult res,
			code: 200
			data: {}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: {errors: [{errorMessage: e.message}]}