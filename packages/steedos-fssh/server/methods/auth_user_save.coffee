Meteor.methods saveAuthUser: (options) ->
	check options, Object
	{ spaceId, auth_name, login_name, login_password } = options
	check spaceId, String
	check auth_name, String
	check login_name, String
	check login_password, String

	currentUserId = @userId
	unless currentUserId
		return true

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
