Admin = {}


# Filter data on server by space field
Admin.selectorCheckSpaceAdmin = (userId) ->
	if Meteor.isClient
		if Steedos.isSpaceAdmin()
			return {space: Session.get("spaceId")}
		else
			return {make_a_bad_selector: 1}

	if Meteor.isServer
		user = db.users.findOne(userId);
		if !user
			return {make_a_bad_selector: 1}
		selector = {}
		if !user.is_cloudadmin
			space_users = db.space_users.find({user: userId}).fetch()
			spaces = []
			_.each space_users, (u)->
				spaces.push(u.space)
			selector.space = {$in: spaces}
		return selector


# Filter data on server by space field
Admin.selectorCheckSpace = (userId) ->
	if Meteor.isClient
		spaceId = Session.get("spaceId");
		if spaceId
			return {space: spaceId}
		else
			return {make_a_bad_selector: 1}


