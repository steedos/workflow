Meteor.methods
	calculateRedirectBox: (insId) ->
		unless this.userId
			throw new Meteor.Error('error', 'user not login.')
		check insId, String
		current_user_id = this.userId
		ins = db.instances.findOne(insId, { fields: { space: 1, flow: 1, state: 1, inbox_users: 1, cc_users: 1, outbox_users: 1, submitter: 1, applicant: 1 } })

		if not ins
			throw new Meteor.Error('error', 'instanceId is wrong or instance not exists.')

		spaceId = ins.space
		flowId = ins.flow

		if db.space_users.find({ space: spaceId, user: current_user_id }).count() is 0
			throw new Meteor.Error('error', 'user is not belong to this space.')

		box = ''

		if (ins.inbox_users?.includes current_user_id) or (ins.cc_users?.includes current_user_id)
			box = 'inbox'
		else if ins.outbox_users?.includes current_user_id
			box = 'outbox'
		else if ins.state is 'draft' and ins.submitter is current_user_id
			box = 'draft'
		else if ins.state is 'pending' and (ins.submitter is current_user_id or ins.applicant is current_user_id)
			box = 'pending'
		else if ins.state is 'completed' and ins.submitter is current_user_id
			box = 'completed'
		else
			# 验证login user_id对该流程有管理申请单的权限
			permissions = permissionManager.getFlowPermissions(flowId, current_user_id)
			space = db.spaces.findOne(spaceId, { fields: { admins: 1 } })
			if (not permissions.includes("admin")) and (not space.admins.includes(current_user_id))
				throw new Meteor.Error('error', "no permission.")
			box = 'monitor'

		return "/workflow/space/#{spaceId}/#{box}/#{insId}"