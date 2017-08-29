
JsonRoutes.add 'post', '/tableau/search/space/:space/flows', (req, res, next) ->
	try
		userId = req.userId

		user = db.users.findOne({_id: userId})

		if !userId || !user
			JsonRoutes.sendResult res,
				code: 401,
			return;
	catch e
		if !userId || !user
			JsonRoutes.sendResult res,
				code: 401,
				data:
					"error": e.message,
					"success": false
			return;

	key = req.body.key

	length = req.body.length

	spaceId = req.params.space

	space = db.spaces.findOne({_id: spaceId})

	space_user = db.space_users.findOne({space: spaceId, user: user._id})

	if space && space_user

		query = {space: spaceId, name : {$regex: key}}

		data = db.flows.find(query, {fields: {_id: 1 , name: 1}, limit: length}).fetch()

		JsonRoutes.sendResult res,
			code: 200,
			data: data;
	else
		JsonRoutes.sendResult res,
			code: 200,
			data: [];


