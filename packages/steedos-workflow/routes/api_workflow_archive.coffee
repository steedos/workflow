JsonRoutes.add 'post', '/api/workflow/archive', (req, res, next) ->
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

		data_str = req.read().toString('utf8')
		hashData = JSON.parse(data_str)
		_.each hashData['Instances'], (instance_from_client) ->
			instance_id = instance_from_client["id"]
			# 获取一个instance
			instance = uuflowManager.getInstance(instance_id)
			space_id = instance.space
			# 获取一个space
			space = uuflowManager.getSpace(space_id)
			# 判断一个instance是否为完成并且未归档状态
			uuflowManager.isInstanceFinishedAndNotArchieved(instance)
			# 获取一个space下的一个user
			space_user = uuflowManager.getSpaceUser(space_id, current_user)
			# 判断一个用户是否是一个instance的提交者 或者space的管理员
			uuflowManager.isInstanceSubmitterOrApplicantOrSpaceAdmin(instance, current_user, space)
			
			setObj = new Object
			setObj.is_archived = true
			setObj.modified = new Date
			setObj.modified_by = current_user

			db.instances.update({_id: instance_id}, {$set: setObj})

		JsonRoutes.sendResult res,
				code: 200
				data: {}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 500
			data: { errors: [{errorMessage: e.stack}] }
	
		