@Users = db.users
@apps = db.apps
@spaces = db.spaces
@space_users = db.space_users
@organizations = db.organizations

db.apps.adminConfig = 
	icon: "globe"
	color: "blue"
	label: ->
		return t("apps")
	tableColumns: [
		{name: "name"},
	]
	selector:  Selector.selectorCheckSpaceAdmin

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
	extraFields: ["name","owner","admins","enable_register"]
	newFormFields: "name,owner,admins,avatar,enable_register"
	editFormFields: "name,owner,admins,avatar,enable_register"
	selector: {_id: -1}

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
	newFormFields: "space,name,parent,sort_no,hidden,users,admins,fullname"
	editFormFields: "name,parent,sort_no,hidden,users,admins"
	selector: Selector.selectorCheckSpaceAdmin
	pageLength: 100

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
	extraFields: ["space", "user", "organizations", "organization", "manager"]
	newFormFields: "space,name,email,company,position,mobile,work_phone,organizations,manager,sort_no,user_accepted"
	editFormFields: "space,name,company,position,mobile,work_phone,organizations,manager,sort_no,user_accepted"
	selector: Selector.selectorCheckSpaceAdmin
	pageLength: 100

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
