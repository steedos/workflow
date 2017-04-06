JsonRoutes.add 'post', '/api/webhook/notify/wenshu', (req, res, next) ->
	try
		hashData = req.body
		
		if _.isEmpty(hashData) or _.isEmpty(hashData.instance) or _.isEmpty(hashData.current_approve)
			JsonRoutes.sendResult res,
				code: 500
				data: { errors: "不具备hook执行条件"}



		JsonRoutes.sendResult res,
				code: 200
				data: {}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 500
			data: { errors: [{errorMessage: e.message}] }
	
		