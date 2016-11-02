db.flows.adminConfig = 
	icon: "globe"
	color: "blue"
	tableColumns: [
		{name: "name"},
		{name: "instance_style"},
	]
	selector: Admin.selectorCheckSpaceAdmin
	showDelColumn: false
	routerAdmin: "/app/admin"


db.flow_roles.adminConfig = 
	icon: "users"
	color: "green"
	label: ->
		return t("flow_roles")
	tableColumns: [
		{name: "name"},
	]
	extraFields: []
	newFormFields: "space,name"
	selector: Admin.selectorCheckSpaceAdmin
	pageLength: 100

db.flow_positions.adminConfig = 
	icon: "users"
	color: "green"
	label: ->
		return t("flow_positions")
	tableColumns: [
		{name: "role_name()"},
		{name: "org_name()"},
		{name: "users_name()"},
	]
	extraFields: ["space", "role", "org", "users"]
	newFormFields: "space,role,org,users"
	selector: Admin.selectorCheckSpaceAdmin
	pageLength: 100
	pub: "tabular_flow_positions"


Meteor.startup ->

	@flows_template = db.flows
	@flow_roles = db.flow_roles
	@flow_positions = db.flow_positions
	AdminConfig?.collections_add
		flows_template: db.flows.adminConfig
		flow_positions: db.flow_positions.adminConfig
		flow_roles: db.flow_roles.adminConfig

