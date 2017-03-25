Meteor.methods saveAuthUsers: (options) ->
	check options, Array
	options.forEach (n, i) ->
		{ spaceId, auth_name, login_name, login_password } = n
		check spaceId, String
		check auth_name, String
		check login_name, String
		check login_password, String

	currentUserId = @userId
	unless currentUserId
		return true

	options.forEach (n, i) ->
		{ spaceId, auth_name, login_name, login_password } = n
		auth_user = db.apps_auth_users.findOne({space:spaceId,auth_name:auth_name,user:currentUserId})
		if auth_user
			db.apps_auth_users.update {
				_id: auth_user._id
			}, $set: {
				login_name: login_name
				login_password: login_password
			}
		else
			db.apps_auth_users.insert
				space: spaceId
				auth_name:auth_name
				user: currentUserId
				login_name:login_name
				login_password:login_password

	return true
