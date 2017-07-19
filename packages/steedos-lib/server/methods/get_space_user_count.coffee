Meteor.methods
	get_space_user_count: (space_id)->
		check space_id, String
		return db.space_users.find({space: space_id}).count()