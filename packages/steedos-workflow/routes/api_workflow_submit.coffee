JsonRoutes.add 'post', '/api/workflow/submit', (req, res, next) ->
	try
		Cookies = Npm.require("cookies")

		cookies = new Cookies(req, res)

		current_user = cookies.get("X-User-Id")

		if not current_user
			throw new Meteor.Error 401, 'Unauthorized'

		current_user_info = db.users.findOne(current_user)

		if not current_user_info
			throw new Meteor.Error 401, 'Unauthorized'

		hashData = req.body
		result = []
		_.each hashData['Instances'], (instance_from_client) ->
			r = uuflowManager.submit_instance(instance_from_client, current_user_info)
			if r.alerts
				result.push(r)

		JsonRoutes.sendResult res,
				code: 200
				data: { result: result }
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}] }
	
		