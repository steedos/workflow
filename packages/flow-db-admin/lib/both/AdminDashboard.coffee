AdminDashboard =
	schemas: {}
	sidebarItems: []
	collectionItems: []
	alertSuccess: (message)->
		Session.set 'adminError', null
		Session.set 'adminSuccess', message
	alertFailure: (message)->
		Session.set 'adminSuccess', null
		Session.set 'adminError', message

	checkAdmin: ->
		#if not Roles.userIsInRole Meteor.userId(), ['admin']
		#	Meteor.call 'adminCheckAdmin'
		#	if (typeof AdminConfig?.nonAdminRedirectRoute == "string")
		#	  Router.go AdminConfig.nonAdminRedirectRoute
		if typeof @.next == 'function'
			@next()
	adminRoutes: ['adminDashboard','adminDashboardView','adminDashboardNew','adminDashboardEdit']
	collectionLabel: (collection)->
		if collection == 'Users'
			'Users'
		else if collection? and typeof AdminConfig.collections[collection].label == 'string'
			AdminConfig.collections[collection].label
		else Session.get 'admin_collection_name'

	addSidebarItem: (title, url, options) ->
		item = title: title
		if _.isObject(url) and typeof options == 'undefined'
			item.options = url
		else
			item.url = url
			item.options = options

		@sidebarItems.push item

	extendSidebarItem: (title, urls) ->
		if _.isObject(urls) then urls = [urls]

		existing = _.find @sidebarItems, (item) -> item.title == title
		if existing
			existing.options.urls = _.union existing.options.urls, urls

	addCollectionItem: (fn) ->
		@collectionItems.push fn

	path: (s) ->
		path = '/admin'
		if typeof s == 'string' and s.length > 0
			path += (if s[0] == '/' then '' else '/') + s
		path

if Meteor.isClient

	AdminDashboard.modalNew = (collectionName) ->
		Session.set('admin_title', collectionName);
		Session.set('admin_subtitle', 'Create New');
		Session.set('admin_collection_page', 'new');
		Session.set('admin_collection_name', collectionName);
		Modal.show("AdminDashboardNewModal")

	AdminDashboard.modalEdit = (collectionName, id) ->
		Session.set('admin_title', collectionName);
		Session.set('admin_subtitle', 'Edit');
		Session.set('admin_collection_page', 'edit');
		Session.set('admin_collection_name', collectionName);
		Session.set('admin_id', id);
		Meteor.subscribe 'adminCollectionDoc', collectionName, id, ()->
			Modal.show("AdminDashboardEditModal")

