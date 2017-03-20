Meteor.methods
	setUsername: (username) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'setUsername' })

		user = Meteor.user()

		if user.username is username
			return username

		nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

		if not nameValidation.test username
			throw new Meteor.Error 'username-invalid', "#{username} is not a valid username, use only letters, numbers, dots, hyphens and underscores"

		if user.username != undefined
			if username.toLowerCase() != user.username.toLowerCase()
				if not  Steedos.checkUsernameAvailability username
					throw new Meteor.Error 'username-unavailable', "<strong>" + username + "</strong> is already in use.", { method: 'setUsername', field: username }
		else
			if not  Steedos.checkUsernameAvailability username
				throw new Meteor.Error 'username-unavailable', "<strong>" + username + "</strong> is already in use.", { method: 'setUsername', field: username }

		db.users.update({_id: user._id}, {$set: {username: username}})

		return username