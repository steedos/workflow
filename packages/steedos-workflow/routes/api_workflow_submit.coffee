JsonRoutes.add 'post', '/api/workflow/submit', (req, res, next) ->
	try
		current_user_info = uuflowManager.check_authorization(req)
		current_user = current_user_info._id

		hashData = req.body
		result = []
		_.each hashData['Instances'], (instance_from_client) ->
			r = uuflowManager.submit_instance(instance_from_client, current_user_info)
			if r.alerts
				result.push(r)
			if not _.isEmpty(instance_from_client['inbox_users'])
				# 如果是转发就需要给当前用户发送push 重新计算badge
				pushManager.send_message_to_specifyUser("current_user", current_user);

		JsonRoutes.sendResult res,
				code: 200
				data: { result: result }
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}] }
	
		