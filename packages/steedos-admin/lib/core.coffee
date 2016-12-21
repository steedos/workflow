Admin = {}


# Filter data on server by space field
Admin.selectorCheckSpaceAdmin = (userId) ->
	unless userId
		return {make_a_bad_selector: 1}

	if Meteor.isClient
		if Steedos.isSpaceAdmin()
			return {space: Session.get("spaceId")}
		else
			return {make_a_bad_selector: 1}

	if Meteor.isServer
		user = db.users.findOne(userId, {fields: {is_cloudadmin: 1}})
		if !user
			return {make_a_bad_selector: 1}
		selector = {}
		if !user.is_cloudadmin
			space_users = db.space_users.find({user: userId}, {fields: {space: 1}}).fetch()
			spaces = []
			_.each space_users, (u)->
				spaces.push(u.space)
			selector.space = {$in: spaces}
		return selector


# Filter data on server by space field
Admin.selectorCheckSpace = (userId) ->
	unless userId
		console.log "Admin.selectorCheckSpace none userId..."
		return {make_a_bad_selector: 1}

	if Meteor.isClient
		spaceId = Session.get("spaceId");
		if spaceId
			if db.space_users.findOne({user: userId,space: spaceId}, {fields: {_id: 1}})
				return {space: spaceId}
			else
				return {make_a_bad_selector: 1}
		else
			return {make_a_bad_selector: 1}

	if Meteor.isServer
		console.log "Admin.selectorCheckSpace isServer..."
		user = db.users.findOne(userId, {fields: {_id: 1}})
		if !user
			return {make_a_bad_selector: 1}
		selector = {}
		space_users = db.space_users.find({user: userId}, {fields: {space: 1}}).fetch()
		spaces = []
		_.each space_users, (u)->
			spaces.push(u.space)
		selector.space = {$in: spaces}
		console.log "Admin.selectorCheckSpace isServer...,selector:#{JSON.stringify(selector)}"
		return selector

