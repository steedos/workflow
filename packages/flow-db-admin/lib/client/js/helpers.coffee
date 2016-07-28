Template.registerHelper('AdminTables', AdminTables);

adminCollections = ->
	collections = {}

	if typeof AdminConfig != 'undefined'  and typeof AdminConfig.collections == 'object'
		collections = AdminConfig.collections

	# collections.Users =
	# 	collectionObject: Meteor.users
	# 	icon: 'user'
	# 	label: 'Users'

	_.map collections, (obj, key) ->
		obj = _.extend obj, {name: key}
		obj = _.defaults obj, {label: key, icon: 'plus', color: 'blue'}
		obj = _.extend obj,
			viewPath: FlowRouter.path "/admin/view/:coll",{coll: key}
			newPath: FlowRouter.path "/admin/new/:coll",{coll: key}

Template.registerHelper 'AdminConfig', ->
	AdminConfig if typeof AdminConfig != 'undefined'

Template.registerHelper 'urlPrefix', ->
	return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX

Template.registerHelper 'admin_skin', ->
	AdminConfig?.skin or 'black-light'

Template.registerHelper 'admin_collections', adminCollections

Template.registerHelper 'admin_collection_name', ->
	Session.get 'admin_collection_name'

Template.registerHelper 'admin_current_id', ->
	Session.get 'admin_id'

Template.registerHelper 'admin_current_doc', ->
	Session.get 'admin_doc'

Template.registerHelper 'admin_is_users_collection', ->
	Session.get('admin_collection_name') == 'Users'

Template.registerHelper 'admin_sidebar_items', ->
	AdminDashboard.sidebarItems

Template.registerHelper 'admin_collection_items', ->
	items = []
	_.each AdminDashboard.collectionItems, (fn) =>
		item = fn @name, '/admin/' + @name
		if item?.title and item?.url
			items.push item
	items

Template.registerHelper 'admin_omit_fields', ->
	if typeof AdminConfig.autoForm != 'undefined' and typeof AdminConfig.autoForm.omitFields == 'object'
		global = AdminConfig.autoForm.omitFields
	if not Session.equals('admin_collection_name','Users') and typeof AdminConfig != 'undefined' and typeof AdminConfig.collections[Session.get 'admin_collection_name'].omitFields == 'object'
		collection = AdminConfig.collections[Session.get 'admin_collection_name'].omitFields
	if typeof global == 'object' and typeof collection == 'object'
		_.union global, collection
	else if typeof global == 'object'
		global
	else if typeof collection == 'object'
		collection

Template.registerHelper 'AdminSchemas', ->
	AdminDashboard.schemas

# Template.registerHelper 'adminIsUserInRole', (_id,role)->
# 	Roles.userIsInRole _id, role

Template.registerHelper 'adminGetUsers', ->
	Meteor.users

Template.registerHelper 'adminGetUserSchema', ->
	if _.has(AdminConfig, 'userSchema')
		schema = AdminConfig.userSchema
	else if typeof Meteor.users._c2 == 'object'
		schema = Meteor.users.simpleSchema()

	return schema

Template.registerHelper 'adminCollectionLabel', (collection)->
	AdminDashboard.collectionLabel(collection) if collection?

Template.registerHelper 'adminCollectionCount', (collection)->
	if collection == 'Users'
		Meteor.users.find().count()
	else
		AdminCollectionsCount.findOne({collection: collection})?.count

Template.registerHelper 'adminTemplate', (collection, mode)->
	if collection?.toLowerCase() != 'users' && typeof AdminConfig?.collections?[collection]?.templates != 'undefined'
		AdminConfig.collections[collection].templates[mode]

Template.registerHelper 'adminGetCollection', (collection)->
	_.find adminCollections(), (item) -> item.name == collection

Template.registerHelper 'adminWidgets', ->
	if typeof AdminConfig.dashboard != 'undefined' and typeof AdminConfig.dashboard.widgets != 'undefined'
		AdminConfig.dashboard.widgets

# Template.registerHelper 'adminUserEmail', (user) ->
# 	if user && user.emails && user.emails[0] && user.emails[0].address
# 		user.emails[0].address
# 	else if user && user.services && user.services.facebook && user.services.facebook.email
# 		user.services.facebook.email
# 	else if user && user.services && user.services.google && user.services.google.email
# 		user.services.google.email

Template.registerHelper 'adminViewPath', (collection)->
		FlowRouter.path "/admin/view/:coll",{coll: collection}

Template.registerHelper 'adminNewPath', (collection)->
		FlowRouter.path "/admin/new/:coll",{coll: collection}

Template.registerHelper 'AdminDashboardPath', ->
	FlowRouter.path 'AdminDashboard'

Template.registerHelper 'isSubReady', (sub) ->
  if sub
    FlowRouter.subsReady sub
  else
    FlowRouter.subsReady()


Template.registerHelper 'admin_fields', ->
	collection = AdminConfig.collections[Session.get 'admin_collection_name']
	if UI.currentView.lookup("admin_current_doc")()
		return collection.editFormFields
	else
		return collection.newFormFields
