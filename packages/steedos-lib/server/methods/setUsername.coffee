Meteor.methods
	setUsername: (space_id, username, user_id) ->
		check(space_id, String);
		check(username, String);

		if !Steedos.isSpaceAdmin(space_id, Meteor.userId()) and user_id
			throw new Meteor.Error 'contact_space_user_needed', 'Only space admins and user-self can change username'

		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'setUsername' })

		unless user_id
			user_id = Meteor.user()._id

		# if !Meteor.settings.public?.accounts?.is_username_skip_minrequiredlength
		# 	if username.length < 6
		# 		throw new Meteor.Error 'username-minrequiredlength', "The minimum length can not be less than 6 digits"

		# if user_id
		# 	user = db.users.findOne({_id: user_id},{fields:{username:1}})
		# else
		# 	user = Meteor.user()

		# if user.username is username
		# 	return username

		# try
		# 	if Meteor.settings.public?.accounts?.UTF8_Names_Validation
		# 		nameValidation = new RegExp '^' + Meteor.settings.public.accounts.UTF8_Names_Validation + '$'
		# 	else
		# 		nameValidation = new RegExp '^[A-Za-z0-9-_.\u00C0-\u017F\u4e00-\u9fa5]+$'
		# catch
		# 	nameValidation = new RegExp '^[A-Za-z0-9-_.\u00C0-\u017F\u4e00-\u9fa5]+$'
		# if not nameValidation.test username

		# 	throw new Meteor.Error 'username-invalid', "#{username} is not a valid username, use only chinese, letters, numbers, dots, hyphens and underscores"

		# if user.username != undefined
		# 	if username.toLowerCase() != user.username.toLowerCase()
		# 		if not  Steedos.checkUsernameAvailability username
		# 			throw new Meteor.Error 'username-unavailable', "<strong>" + username + "</strong> is already in use.", { method: 'setUsername', field: username }
		# else
		# 	if not  Steedos.checkUsernameAvailability username
		# 		throw new Meteor.Error 'username-unavailable', "<strong>" + username + "</strong> is already in use.", { method: 'setUsername', field: username }
		# db.users.validateUsername(username, user_id)
		db.users.update({_id: user_id}, {$set: {username: username}})

		return username
