Selector = {}


# Filter data on server by space field
Selector.selectorCheckSpaceAdmin = (userId) ->
	if Meteor.isClient
		if Steedos.isSpaceAdmin()
			return {space: Session.get("spaceId")}
		else
			return {make_a_bad_selector: 1}

	if Meteor.isServer
		return {}


db.space_user_signs.adminConfig =
	icon: "globe"
	color: "blue"
	tableColumns: [
		{name: "userName()"},
		{name: "signImage()"}
	]
	extraFields: ["space", "user", 'sign']
	routerAdmin: "/admin"
	selector: Selector.selectorCheckSpaceAdmin

Meteor.startup ->
	@space_user_signs = db.space_user_signs
	AdminConfig?.collections_add
		space_user_signs: db.space_user_signs.adminConfig