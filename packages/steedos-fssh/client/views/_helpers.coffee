FSSH.helpers =
	steedosEmail: ->
		currentUser = Meteor.user()
		unless currentUser
			return ""
		if currentUser.emails?.length > 0
			currentUser.emails[0].address

	authLoginName: (auth_name)->
		spaceId = Steedos.spaceId()
		currentUserId = Meteor.userId()
		auth_user = db.apps_auth_users.findOne({space:spaceId,auth_name:auth_name,user:currentUserId})
		if auth_user
			return auth_user.login_name
		else
			return ""