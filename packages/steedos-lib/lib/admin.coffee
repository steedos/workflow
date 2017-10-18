Selector = {}


# Filter data on server by space field
Selector.selectorCheckSpaceAdmin = (userId) ->
	if Meteor.isClient
		if Steedos.isSpaceAdmin()
			return {space: Session.get("spaceId")}
		else
			return {_id: -1}

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

db.billing_pay_records.adminConfig =
	icon: "globe"
	color: "blue"
	tableColumns: [
		{name: "created"},
		{name: "modules"},
		{name: "user_count"},
		{name: "end_date"},
		{name: "total_fee"},
		{name: "paid"}
	]
	extraFields: ["space"]
	routerAdmin: "/admin"
	selector: Selector.selectorCheckSpaceAdmin
	showEditColumn: false
	showDelColumn: false
	disableAdd: true
	pageLength: 100
	order: [[0, "desc"]]

Meteor.startup ->
	@space_user_signs = db.space_user_signs
	@billing_pay_records = db.billing_pay_records
	AdminConfig?.collections_add
		space_user_signs: db.space_user_signs.adminConfig
		billing_pay_records: db.billing_pay_records.adminConfig