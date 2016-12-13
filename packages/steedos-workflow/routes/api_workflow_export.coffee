JsonRoutes.add 'post', '/api/workflow/archive', (req, res, next) ->
	try
		

		JsonRoutes.sendResult res,
				code: 200
				data: {}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 500
			data: { errors: [{errorMessage: e.stack}] }
	
		