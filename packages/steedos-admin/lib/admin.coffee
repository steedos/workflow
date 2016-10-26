@Users = db.users
@apps = db.apps
@spaces = db.spaces
@space_users = db.space_users
@organizations = db.organizations
@flow_roles = db.flow_roles
@flow_positions = db.flow_positions

db.apps.adminConfig = 
	icon: "globe"
	color: "blue"
	label: ->
		return t("apps")
	tableColumns: [
		{name: "name"},
	]
	selector: {space: "-1"}
	routerAdmin: "/steedos/admin"

db.spaces.adminConfig = 
	icon: "globe"
	color: "blue"
	label: ->
		return t("spaces")
	tableColumns: [
		{name: "name"},
		{name: "owner_name()"},
		{name: "is_paid"},
	]
	extraFields: ["owner"]
	newFormFields: "name"
	selector: {_id: -1}
	routerAdmin: "/steedos/admin"

db.organizations.adminConfig =
	icon: "sitemap"
	color: "green"
	label: ->
		return t("organizations")
	tableColumns: [
		{name: "fullname"},
		{name: "users_count()"},
	]
	extraFields: ["space", "name", "users"]
	newFormFields: "space,name,parent"
	editFormFields: "name,parent"
	selector: {space: "-1"}
	pageLength: 100
	routerAdmin: "/steedos/admin"

db.space_users.adminConfig = 
	icon: "users"
	color: "green"
	label: ->
		return t("space_users")
	tableColumns: [
		{name: "name"},
		{name: "email"},
		{name: "organization_name()"},
		{name: "user_accepted"}
	]
	extraFields: ["space", "user", 'organizations', "manager"]
	newFormFields: "space,name,email,organizations,manager,user_accepted"
	editFormFields: "space,name,organizations,manager,user_accepted"
	selector: {space: "-1"}
	pageLength: 100
	routerAdmin: "/steedos/admin"

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
	selector: {space: "-1"}
	pageLength: 100
	routerAdmin: "/steedos/admin"

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
	extraFields: ["role", "org", "users"]
	newFormFields: "space,role,org,users"
	selector: {space: "-1"}
	pageLength: 100
	routerAdmin: "/steedos/admin"

@AdminConfig = 
	name: "Steedos Admin"
	skin: "green"
	layout: "adminLayout"
	userSchema: null,
	userSchema: db.users._simpleSchema,
	autoForm:
		omitFields: ['createdAt', 'updatedAt', 'created', 'created_by', 'modified', 'modified_by']
	collections: 
		spaces: db.spaces.adminConfig
		organizations: db.organizations.adminConfig
		space_users: db.space_users.adminConfig
		flow_roles: db.flow_roles.adminConfig
		flow_positions: db.flow_positions.adminConfig
		apps: db.apps.adminConfig

# set first user as admin
# if Meteor.isServer
# 	adminUser = Meteor.users.findOne({},{sort:{createdAt:1}})
# 	if adminUser
# 		adminUserId = adminUser._id
# 		if !Roles.userIsInRole(adminUserId, ['admin'])
# 			Roles.addUsersToRoles adminUserId, ['admin'], Roles.GLOBAL_GROUP

if Meteor.isClient
	Meteor.startup ->
		Tracker.autorun ->

			if AdminTables["spaces"]
				AdminTables["spaces"].selector = {owner: Meteor.userId()}

			if Session.get("spaceId")
				if AdminTables["apps"]
					AdminTables["apps"].selector = {space: Session.get("spaceId")}
				if AdminTables["space_users"]
					AdminTables["space_users"].selector = {space: Session.get("spaceId")}
				if AdminTables["organizations"]
					AdminTables["organizations"].selector = {space: Session.get("spaceId")}
				if AdminTables["flow_roles"]
					AdminTables["flow_roles"].selector = {space: Session.get("spaceId")}
				if AdminTables["flow_positions"]
					AdminTables["flow_positions"].selector = {space: Session.get("spaceId")}