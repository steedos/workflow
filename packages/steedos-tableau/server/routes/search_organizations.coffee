
JsonRoutes.add 'post', '/tableau/search/space/:space/organizations', (req, res, next) ->
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

		query = {space: spaceId, fullname : {$regex: key}}

		if !space.admins?.includes(user._id)
			orgs = space_user.organizations || []
			orgs_childs = db.organizations.find({parents: {$in: orgs}}, {
				fields: {
					_id: 1
				}
			}).fetch();

			orgs = orgs.concat(orgs_childs.getProperty("_id"))

			query._id = {$in: orgs}

		data = db.organizations.find(query, {fields: {_id: 1 , fullname: 1}, limit: length}).fetch()

		JsonRoutes.sendResult res,
			code: 200,
			data: data;
	else
		JsonRoutes.sendResult res,
			code: 200,
			data: [];


