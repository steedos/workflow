JsonRoutes.add 'post', '/api/workflow/relocate', (req, res, next) ->
	try
		current_user_info = uuflowManager.check_authorization(req)
		current_user = current_user_info._id

		hashData = req.body
		_.each hashData['Instances'], (instance_from_client) ->

			instance = uuflowManager.getInstance(instance_from_client["id"])
			# 验证instance为审核中状态
			uuflowManager.isInstancePending(instance)
			# 验证当前执行转签核的trace未结束
			last_trace_from_client = _.last(instance_from_client["traces"])
			last_trace = _.find(instance.traces, (t)->
				return t._id is last_trace_from_client["id"]
			)
			if last_trace.is_finished is true
				return

			# 验证login user_id对该流程有管理申请单的权限
			permissions = permissionManager.getFlowPermissions(instance.flow, current_user)
			space = db.spaces.findOne(instance.space)
			if (not permissions.includes("admin")) and (not space.admins.includes(current_user))
				throw new Meteor.Error('error!', "用户没有对当前流程的管理权限")

			space_id             = instance.space
			instance_id          = last_trace.instance
			inbox_users          = instance.inbox_users
			relocate_inbox_users = instance_from_client["relocate_inbox_users"]
			relocate_comment     = instance_from_client["relocate_comment"]
			relocate_next_step   = instance_from_client["relocate_next_step"]
			not_in_inbox_users   = _.difference(inbox_users, relocate_inbox_users)
			new_inbox_users      = _.difference(relocate_inbox_users, inbox_users)

			# 获取一个flow
			flow = uuflowManager.getFlow(instance.flow)
			next_step = uuflowManager.getStep(instance, flow, relocate_next_step)
			next_step_type = next_step.step_type
			current_setp = uuflowManager.getStep(instance, flow, last_trace.step)
			current_setp_type = current_setp.step_type

			traces = instance.traces
			setObj = new Object
			now = new Date
			i = 0
			while i < traces.length
				if traces[i]._id is last_trace._id
					# 更新当前trace.approve记录
					h = 0
					while h < traces[i].approves.length
						traces[i].approves[h].start_date = now
						traces[i].approves[h].finish_date = now
						traces[i].approves[h].read_date = now
						traces[i].approves[h].is_error = false
						traces[i].approves[h].is_read = true
						traces[i].approves[h].is_finished = true
						traces[i].approves[h].finish_date = now
						traces[i].approves[h].judge = ""

						h++

					# 在同一trace下插入重定位操作者的approve记录
					current_space_user = uuflowManager.getSpaceUser(space_id, current_user)
					current_user_organization = db.organizations.findOne(current_space_user.organization)
					relocate_appr = new Object
					relocate_appr._id = new Mongo.ObjectID()._str
					relocate_appr.instance = instance_id
					relocate_appr.trace = traces[i]._id
					relocate_appr.is_finished = true
					relocate_appr.user = current_user
					relocate_appr.user_name = current_user_info.name
					relocate_appr.handler = current_user
					relocate_appr.handler_name = current_user_info.name
					relocate_appr.handler_organization = current_space_user.organization
					relocate_appr.handler_organization_name = current_user_organization.name
					relocate_appr.handler_organization_fullname = current_user_organization.fullname
					relocate_appr.start_date = now
					relocate_appr.finish_date = now
					relocate_appr.due_date = traces[i].due_date
					relocate_appr.read_date = now
					relocate_appr.judge = "relocated"
					relocate_appr.is_read = true
					relocate_appr.description = relocate_comment
					relocate_appr.is_error = false
					relocate_appr.values = new Object
					traces[i].approves.push(relocate_appr)

					# 更新当前trace记录
					traces[i].is_finished = true
					traces[i].finish_date = now
					traces[i].judge = "relocated"

				i++

			if next_step_type is "end"
				# 插入下一步trace记录
				newTrace = new Object
				newTrace._id = new Mongo.ObjectID()._str
				newTrace.instance = instance_id
				newTrace.previous_trace_ids = [last_trace._id]
				newTrace.is_finished = true
				newTrace.step = relocate_next_step
				newTrace.start_date = now
				newTrace.finish_date = now
				if next_step.timeout_hours
					due_time = new Date().getTime() + (1000 * 60 * 60 * next_step.timeout_hours)
					newTrace.due_date = new Date(due_time)				
				newTrace.approves = []
				# 更新instance记录
				setObj.state = "completed"
				setObj.inbox_users = []
				setObj.final_decision = ""
			else
				# 插入下一步trace记录
				newTrace = new Object
				newTrace._id = new Mongo.ObjectID()._str
				newTrace.instance = instance_id
				newTrace.previous_trace_ids = [last_trace._id]
				newTrace.is_finished = false
				newTrace.step = relocate_next_step
				newTrace.start_date = now
				if next_step.timeout_hours
					due_time = new Date().getTime() + (1000 * 60 * 60 * next_step.timeout_hours)
					newTrace.due_date = new Date(due_time)				
				newTrace.approves = []
				_.each(relocate_inbox_users, (next_step_user_id)->
					# 插入下一步trace.approve记录
					newApprove = new Object
					newApprove._id = new Mongo.ObjectID()._str
					newApprove.instance = instance_id
					newApprove.trace = newTrace._id
					newApprove.is_finished = false
					newApprove.user = next_step_user_id

					handler_info = db.users.findOne(next_step_user_id)
					newApprove.user_name = handler_info.name
					newApprove.handler = next_step_user_id
					newApprove.handler_name = handler_info.name

					next_step_space_user = uuflowManager.getSpaceUser(space_id, next_step_user_id)
					# 获取next_step_user所在的部门信息
					next_step_user_org_info = uuflowManager.getSpaceUserOrgInfo(next_step_space_user)
					newApprove.handler_organization = next_step_user_org_info["organization"]
					newApprove.handler_organization_name = next_step_user_org_info["organization_name"]
					newApprove.handler_organization_fullname = next_step_user_org_info["organization_fullname"]

					newApprove.start_date = now
					newApprove.is_read = false
					newApprove.is_error = false
					newApprove.values = new Object

					newTrace.approves.push(newApprove)
				)
				setObj.inbox_users = relocate_inbox_users

			instance.outbox_users.push(current_user)
			instance.outbox_users = instance.outbox_users.concat(inbox_users)
			setObj.outbox_users = _.uniq(instance.outbox_users)
			setObj.modified = now
			setObj.modified_by = current_user
			traces.push(newTrace)
			setObj.traces = traces

			r = db.instances.update({_id: instance_id}, {$set: setObj})
			if r
				ins = uuflowManager.getInstance(instance_id)
				# 给被删除的inbox_users 和 当前用户 发送push
				pushManager.send_message_current_user(current_user_info)
				_.each(not_in_inbox_users, (user_id)->
					if user_id isnt current_user
						pushManager.send_message_to_specifyUser("current_user", user_id)
				)
				# 提取instances.outbox_users数组和填单人、申请人
				_users = new Array
				_users.push(ins.applicant)
				_users.push(ins.submitter)
				_users = _.uniq(_users.concat(ins.outbox_users))
				_.each(_users, (user_id)->
					pushManager.send_message_to_specifyUser("current_user", user_id)
				)

				# 给新加入的inbox_users发送push message
				pushManager.send_instance_notification("reassign_new_inbox_users", ins, relocate_comment, current_user_info)

		JsonRoutes.sendResult res,
				code: 200
				data: {}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}] }
	
		