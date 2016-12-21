JsonRoutes.add 'post', '/api/workflow/remove', (req, res, next) ->
	try
		Cookies = Npm.require("cookies")

		cookies = new Cookies(req, res)

		current_user = cookies.get("X-User-Id")

		if not current_user
			JsonRoutes.sendResult res,
				code: 500
				data: {}

		current_user_info = db.users.findOne(current_user)

		if not current_user_info
			JsonRoutes.sendResult res,
				code: 500
				data: {}

		hashData = req.body

		inserted_instances = new Array

		_.each hashData['Instances'], (instance_from_client) ->
			# 获取一个instance
			instance = uuflowManager.getInstance(instance_from_client["id"])
			space_id = instance.space
			# 获取一个space
			space = uuflowManager.getSpace(space_id)
			# 获取一个space下的一个user
			space_user = uuflowManager.getSpaceUser(space_id, current_user)
			# 判断一个用户是否是一个instance的提交者或者申请人 或SpaceAdmin或FlowAdmin
			permissions = permissionManager.getFlowPermissions(instance.flow, current_user)
			if (instance.submitter isnt current_user) and (not space.admins.includes current_user ) and (not permissions.includes "admin")
				throw new  Meteor.Error('error!', "您不能删除此申请单。")

			delete_obj = db.instances.findOne(instance_from_client["id"])
			delete_obj.deleted = new Date
			delete_obj.deleted_by = current_user

			db.deleted_instances.insert(delete_obj)

			# 删除instance
			db.instances.remove(instance_from_client["id"])

		JsonRoutes.sendResult res,
			code: 200
			data: { inserts: inserted_instances}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 500
			data: { errors: [{errorMessage: e.stack}]}
	
		