JsonRoutes.add 'POST', '/tableau/access_token', (req, res, next) ->

	data = req.body

	username = data?.username

	email = data?.email

	password = data?.password

	console.log "data", data

	if username
		user = db.users.findOne({username: username})
	else if email
		user = db.users.findOne({"emails.address": email})

	if user
		result = Accounts._checkPassword user, password

		if result.error
			JsonRoutes.sendResult res,
				code: 401,
				data:
					"error": e.message,
					"success": false
			return;
		else
			console.log "user", user
			access_token = SteedosTableau._get_tableau_access_token(user._id)

			JsonRoutes.sendResult res,
				code: 200,
				data:
					"data": {access_token: access_token}
			return;


	JsonRoutes.sendResult res,
		code: 401,
		data:
			"error": "invalid username or password",
			"success": false
	return;