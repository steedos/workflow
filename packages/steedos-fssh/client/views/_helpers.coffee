FSSH.helpers =
	steedosEmail: ->
		currentUser = Meteor.user()
		unless currentUser
			return ""
		if currentUser.emails?.length > 0
			currentUser.emails[0].address


