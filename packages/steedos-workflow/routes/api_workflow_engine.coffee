JsonRoutes.add 'post', '/api/workflow/engine', (req, res, next) ->
	try
		current_user_info = uuflowManager.check_authorization(req)
		current_user = current_user_info._id

		hashData = req.body

		_.each hashData['Approvals'], (approve_from_client) ->
			instance_id = approve_from_client["instance"]
			trace_id = approve_from_client["trace"]
			approve_id = approve_from_client["_id"]
			values = approve_from_client["values"]
			if not values then values = new Object
			next_steps = approve_from_client["next_steps"]
			judge = approve_from_client["judge"]
			description = approve_from_client["description"]
			geolocation = approve_from_client["geolocation"]

			setObj = new Object

			# 获取一个instance
			instance = uuflowManager.getInstance(instance_id)
			space_id = instance.space
			flow_id = instance.flow
			# 获取一个space
			space = uuflowManager.getSpace(space_id)
			applicant_id = instance.applicant
			# 校验申请人user_accepted = true
			checkApplicant = uuflowManager.getSpaceUser(space_id, applicant_id)
			# 获取一个flow
			flow = uuflowManager.getFlow(flow_id)
			# 获取一个space下的一个user
			space_user = uuflowManager.getSpaceUser(space_id, current_user)
			# 获取space_user所在的部门信息
			space_user_org_info = uuflowManager.getSpaceUserOrgInfo(space_user)
			# 获取一个trace
			trace = uuflowManager.getTrace(instance, trace_id)
			# 获取一个approve
			approve = uuflowManager.getApprove(trace, approve_id)
			# 判断一个trace是否为未完成状态
			uuflowManager.isTraceNotFinished(trace)
			# 判断一个approve是否为未完成状态
			uuflowManager.isApproveNotFinished(approve)
			# 判断一个instance是否为审核中状态
			uuflowManager.isInstancePending(instance)
			# 判断当前用户是否approve 对应的处理人或代理人
			uuflowManager.isHandlerOrAgent(approve, current_user)

			# 先执行审核状态暂存的操作
			# ================begin================
			step = uuflowManager.getStep(instance, flow, trace.step)
			step_type = step.step_type
			instance_trace = _.find(instance.traces, (trace)->
				return trace._id is trace_id
			)

			trace_approves = instance_trace.approves

			i = 0
			while i < trace_approves.length
				if trace_approves[i]._id is approve_id
					trace_approves[i].geolocation = geolocation
					if step_type is "condition"
					else if step_type is "start" or step_type is "submit"
						trace_approves[i].judge = "submitted"
						trace_approves[i].description = description
					else if step_type is "sign" or step_type is "counterSign"
						# 如果是会签并且前台没有显示核准驳回已阅的radio则给judge默认submitted
						if step_type is "counterSign" and not judge
							judge = 'submitted'
						# 判断前台传的judge是否合法
						uuflowManager.isJudgeLegal(judge)
						trace_approves[i].judge = judge
						trace_approves[i].description = description

					trace_approves[i].next_steps = next_steps
					trace_approves[i].is_read = true
					if trace_approves[i].read_date is null
						trace_approves[i].read_date = new Date
					trace_approves[i].values = values

				i++

			setObj["traces.$.approves"] = trace_approves
			# 更新instance记录
			setObj.modified = new Date
			setObj.modified_by = current_user

			db.instances.update({_id: instance_id, "traces._id": trace_id}, {$set: setObj})
			# ================end================
			instance = uuflowManager.getInstance(instance_id)
			updateObj = new Object

			if next_steps is null or next_steps.length is 0
				throw new Meteor.Error('error!', '还未指定下一步和处理人，操作失败')
			else
				# 验证next_steps里面是否只有一个step
				if next_steps.length > 1
					throw new Meteor.Error('error!', '不能指定多个后续步骤')
				else
					# 校验下一步处理人user_accepted = true
					_.each next_steps[0]["users"], (next_step_user) ->
						checkSpaceUser = uuflowManager.getSpaceUser(space_id, next_step_user)

				if step_type is "start" or step_type is "submit" or step_type is "condition" 
					updateObj = uuflowManager.engine_step_type_is_start_or_submit_or_condition(instance_id, trace_id, approve_id, next_steps, space_user_org_info, judge, instance, flow, step, current_user, current_user_info)
				else if step_type is "sign"
					updateObj = uuflowManager.engine_step_type_is_sign(instance_id, trace_id, approve_id, next_steps, space_user_org_info, judge, instance, flow, step, current_user, current_user_info, description)
				else if step_type is "counterSign"
					updateObj = uuflowManager.engine_step_type_is_counterSign(instance_id, trace_id, approve_id, next_steps, space_user_org_info, judge, instance, flow, step, current_user, current_user_info)
				else if step_type is "end"
					throw new Meteor.Error('error!', 'end结点出现approve，服务器错误')

				form = db.forms.findOne(instance.form)
				updateObj.keywords = uuflowManager.caculateKeywords(updateObj.values, form, instance.form_version)
				db.instances.update({_id: instance_id}, {$set: updateObj})

			instance = uuflowManager.getInstance(instance_id)
			instance_trace = _.find(instance.traces, (trace)->
				return trace._id is trace_id
			)
			next_step_id = next_steps[0]["step"]
			next_step = uuflowManager.getStep(instance, flow, next_step_id)
			next_step_type = next_step.step_type
			#发送消息开始
			if "completed" is instance.state
				if "approved" is instance.final_decision
					#通知填单人、申请人
					pushManager.send_instance_notification("approved_completed_applicant", instance, description, current_user_info)
				else if "rejected" is instance.final_decision
					#通知填单人、申请人
					pushManager.send_instance_notification("rejected_completed_applicant", instance, description, current_user_info)
				else
					#通知填单人、申请人
					pushManager.send_instance_notification("submit_completed_applicant", instance, description, current_user_info)
			
			else if "pending" is instance.state
				if "rejected" is instance_trace.judge and instance_trace.is_finished is true
					if 'start' is next_step_type
						#驳回给申请人时，发送短消息
						pushManager.send_instance_notification("submit_pending_rejected_applicant_inbox", instance, description, current_user_info)
					else
						#通知填单人、申请人
						pushManager.send_instance_notification("submit_pending_rejected_applicant", instance, description, current_user_info)
						# 发送消息给下一步处理人
						pushManager.send_instance_notification("submit_pending_rejected_inbox", instance, description, current_user_info)
				else if instance_trace.is_finished is false
					# 会签 并且当前trace未结束
					# 发送push消息 给 inbox_users

				else
					# 发送消息给下一步处理人
					pushManager.send_instance_notification("submit_pending_inbox", instance, description, current_user_info)
			#发送消息给当前用户
			pushManager.send_message_current_user(current_user_info)

			# 如果已经配置webhook并已激活则触发
			pushManager.triggerWebhook(flow_id, instance, approve_from_client)

		JsonRoutes.sendResult res,
			code: 200
			data: {}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}]}
	
		