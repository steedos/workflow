Meteor.methods
	instance_return: (approve, reason)->
		check(approve, Object)

		current_user = this.userId
		instance_id = approve.instance

		ins = uuflowManager.getInstance(instance_id)
		space_id = ins.space

		# - 待审核箱
		if ins.state isnt "pending" or !ins.inbox_users.includes(current_user)
			throw new Meteor.Error('error!', "不符合退回条件")

		# - 文件不是传阅
		if approve.type is "cc" and ins.cc_users.includes(current_user)
			throw new Meteor.Error('error!', "不符合退回条件")

		# - 签核历程中当前步骤上一步骤不是会签
		if ins.traces.length < 2
			throw new Meteor.Error('error!', "不符合退回条件")
		flow = uuflowManager.getFlow(ins.flow)
		pre_trace = ins.traces[ins.traces.length - 2]
		pre_step = uuflowManager.getStep(ins, flow, pre_trace.step)
		if pre_step.step_type is "counterSign"
			throw new Meteor.Error('error!', "不符合退回条件")

		# - 当前步骤为填写
		last_trace = _.last(ins.traces)
		current_step = uuflowManager.getStep(ins, flow, last_trace.step)
		if current_step.step_type isnt "submit"
			throw new Meteor.Error('error!', "不符合退回条件")

		# - 参数approve中trace与当前获取的trace是否匹配
		if approve.trace isnt last_trace._id
			throw new Meteor.Error('error!', "不符合退回条件")

		new_inbox_users = new Array
		_.each pre_trace.approves, (a)->
			if (!a.type or a.type is "draft") and (!a.judge or a.judge is "submitted" or a.judge is "approved" or a.judge is "rejected")
				new_inbox_users.push(a.user)

		traces = ins.traces
		setObj = new Object
		now = new Date
		_.each traces, (t)->
			if t._id is last_trace._id
				if not t.approves
					t.approves = new Array
				_.each t.approves, (a)->
					if !a.type and !a.judge
						a.start_date = now
						a.finish_date = now
						a.read_date = now
						a.is_error = false
						a.is_read = true
						a.is_finished = true
						a.judge = "returned"
						a.cost_time = a.finish_date - a.start_date
						a.description = reason
				# 更新当前trace记录
				t.is_finished = true
				t.finish_date = now
				t.judge = "returned"

		# 插入下一步trace记录
		newTrace = new Object
		newTrace._id = new Mongo.ObjectID()._str
		newTrace.instance = instance_id
		newTrace.previous_trace_ids = [last_trace._id]
		newTrace.is_finished = false
		newTrace.step = pre_trace.step
		newTrace.name = pre_trace.name
		newTrace.start_date = now
		if pre_step.timeout_hours
			due_time = new Date().getTime() + (1000 * 60 * 60 * pre_step.timeout_hours)
			newTrace.due_date = new Date(due_time)
		newTrace.approves = []
		_.each new_inbox_users, (next_step_user_id)->
			# 插入下一步trace.approve记录
			newApprove = new Object
			newApprove._id = new Mongo.ObjectID()._str
			newApprove.instance = instance_id
			newApprove.trace = newTrace._id
			newApprove.is_finished = false
			newApprove.user = next_step_user_id

			handler_info = db.users.findOne(next_step_user_id, {fields: {name: 1}})
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
			uuflowManager.setRemindInfo(ins.values, newApprove)
			newTrace.approves.push(newApprove)

		setObj.inbox_users = new_inbox_users
		setObj.state = "pending"

		ins.outbox_users.push(current_user)
		setObj.outbox_users = _.uniq(ins.outbox_users)
		setObj.modified = now
		setObj.modified_by = current_user
		traces.push(newTrace)
		setObj.traces = traces

		r = db.instances.update({_id: instance_id}, {$set: setObj})
		if r
			# 新inbox_users 和 当前用户 发送push
			pushManager.send_message_to_specifyUser("current_user", current_user)
			_.each new_inbox_users, (user_id)->
				if user_id isnt current_user
					pushManager.send_message_to_specifyUser("current_user", user_id)
			
		return true