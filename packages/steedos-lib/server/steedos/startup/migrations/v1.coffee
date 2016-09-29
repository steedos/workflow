Meteor.startup ->
	Migrations.add
		version: 1
		up: ->
			# db.users.find().forEach (user) ->
			# 	modifier = 
			# 		$set: {}

			# 	if user.is_cloud_admin
			# 		Roles.addUsersToRoles user._id, "admin", Roles.GLOBAL_GROUP
					
			# 	Meteor.users.update	{_id: user._id}, modifier