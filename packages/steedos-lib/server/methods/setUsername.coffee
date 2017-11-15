Meteor.methods
	setUsername: (space_id, username, user_id) ->
		check(space_id, String);
		check(username, String);

		if !Steedos.isSpaceAdmin(space_id, Meteor.userId()) and user_id
			throw new Meteor.Error(400, 'contact_space_user_needed')

		if not Meteor.userId()
			throw new Meteor.Error(400,'error-invalid-user')

		unless user_id
			user_id = Meteor.user()._id

		db.users.update({_id: user_id}, {$set: {username: username}})

		return username
