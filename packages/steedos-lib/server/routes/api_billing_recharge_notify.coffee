JsonRoutes.add 'get', '/api/billing/recharge/notify', (req, res, next) ->
	try
		console.log "===========/api/billing/recharge/notify=============="
		console.log req.body

		JsonRoutes.sendResult res,
			code: 200
			data: { status: "success", data: apps}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}]}
	
		