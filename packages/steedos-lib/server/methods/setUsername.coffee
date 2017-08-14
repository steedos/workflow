Meteor.methods
	setUsername: (username, user_id) ->
		check(username, String);

		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'setUsername' })

		if user_id
			user = db.users.findOne({_id: user_id},{fields:{username:1}})
		else
			user = Meteor.user()

		if user.username is username
			return username

		try
			if Meteor.settings.public?.accounts?.UTF8_Names_Validation
				nameValidation = new RegExp '^' + Meteor.settings.public.accounts.UTF8_Names_Validation + '$'
			else
				nameValidation = new RegExp '^[A-Za-z0-9-_.\u00C0-\u017F\u4e00-\u9fa5]+$'
		catch
			nameValidation = new RegExp '^[A-Za-z0-9-_.\u00C0-\u017F\u4e00-\u9fa5]+$'
		if not nameValidation.test username

			throw new Meteor.Error 'username-invalid', "#{username} is not a valid username, use only chinese, letters, numbers, dots, hyphens and underscores"

		if user.username != undefined
			if username.toLowerCase() != user.username.toLowerCase()
				if not  Steedos.checkUsernameAvailability username
					throw new Meteor.Error 'username-unavailable', "<strong>" + username + "</strong> is already in use.", { method: 'setUsername', field: username }
		else
			if not  Steedos.checkUsernameAvailability username
				throw new Meteor.Error 'username-unavailable', "<strong>" + username + "</strong> is already in use.", { method: 'setUsername', field: username }

		db.users.update({_id: user._id}, {$set: {username: username}})

		return username
