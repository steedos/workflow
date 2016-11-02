Admin = {}

if Meteor.isServer

	# Filter data on server by space field
	Admin.changeSelectorCheckSpace = (selector, userId) ->
		if !selector.space
			return {make_a_bad_selector: 1}
		user = db.users.findOne(userId);
		if !user
			return {make_a_bad_selector: 1}
		if user.is_cloudadmin
			return selector
		space_user = db.space_users.find({user: userId, space: selector.space})
		if !space_user.count()
			return {make_a_bad_selector: 1}
		return selector

	# Filter data on server by space field
	Admin.changeSelectorCheckSpaceAdmin = (selector, userId) ->
		user = db.users.findOne(userId);
		if !user
			return {make_a_bad_selector: 1}
		if user.is_cloudadmin
			return selector
		if !selector.space
			return {make_a_bad_selector: 1}
		space_user = db.space_users.find({user: userId, space: selector.space})
		if !space_user.count()
			return {make_a_bad_selector: 1}
		if !Steedos.isSpaceAdmin(selector.space, userId)
			return {make_a_bad_selector: 1}
		return selector
