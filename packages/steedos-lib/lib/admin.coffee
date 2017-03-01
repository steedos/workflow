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

db.billings.adminConfig =
	icon: "globe"
	color: "blue"
	tableColumns: [
		{name: "billing_date_i18n()"},
		{name: "transaction_i18n()"},
		{name: "user_count"},
		{name: "debits"},
		{name: "credits"},
		{name: "balance"}
	]
	extraFields: ["space", "billing_date", "transaction"]
	routerAdmin: "/admin"
	selector: Selector.selectorCheckSpaceAdmin
	showEditColumn: false
	showDelColumn: false
	disableAdd: true
	pageLength: 100

Meteor.startup ->
	@space_user_signs = db.space_user_signs
	@billings = db.billings
	AdminConfig?.collections_add
		space_user_signs: db.space_user_signs.adminConfig
		billings: db.billings.adminConfig