JsonRoutes.add 'get', '/api/workflow/open/get/:ins_id', (req, res, next) ->
	try
		ins_id = req.params.ins_id

		current_user = req.headers['X-User-Id']

		auth_token = req.headers['X-Auth-Token']

		space_id = req.headers['X_Space_Id']

		if not current_user
			throw new Meteor.Error('error', 'need header X-User-Id')

		if not auth_token
			throw new Meteor.Error('error', 'need header X-Auth-Token')

		if not space_id
			throw new Meteor.Error('error', 'need header X_Space_Id')

		# 校验space是否存在
		uuflowManager.getSpace(space_id)
		# 校验当前登录用户是否是space的管理员
		uuflowManager.isSpaceAdmin(current_user, space_id)

		instance = db.instances.findOne(ins_id)
		if not instance
			throw new Meteor.Error('error', 'can not find user')

		if db.space_users.find({space: instance.space, user: current_user}).count() is 0
			throw new Meteor.Error('error', 'auth_token is wrong')

		# 权限：仅以下人员可以查看申请单详情：提交者、申请者、经手者、本流程的管理员、本流程的观察员、本工作区的管理员、本工作区的所有者。
		perm_users = new Array
		perm_users.push(instance.submitter)
		perm_users.push(instance.applicant)
		if instance.outbox_users
			perm_users = perm_users.concat(instance.outbox_users)
		if instance.inbox_users
			perm_users = perm_users.concat(instance.inbox_users)
		space = db.spaces.findOne(instance.space)
		perm_users = perm_users.concat(space.admins)

		permissions = permissionManager.getFlowPermissions(instance.flow, current_user)

		if (not perm_users.includes(current_user)) and (not permissions.includes("monitor")) and (not permissions.includes("admin"))
			throw new Meteor.Error('error', 'no permission')

		JsonRoutes.sendResult res,
			code: 200
			data: { status: "success", data: instance}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}]}
	
		