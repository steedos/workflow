JsonRoutes.add 'post', '/api/workflow/drafts', (req, res, next) ->
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
			new_ins_id = uuflowManager.create_instance(instance_from_client, current_user_info)
			inserted_instances.push(new_ins_id)

		JsonRoutes.sendResult res,
			code: 200
			data: { inserts: inserted_instances}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 500
			data: { errors: [{errorMessage: e.stack}]}
	
		