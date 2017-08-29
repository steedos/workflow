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
	adminRoutes: ['adminDashboard', 'adminDashboardView', 'adminDashboardNew', 'adminDashboardEdit']
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

	AdminDashboard.modalNew = (collectionName, doc, callback) ->
		Session.set('admin_title', collectionName);
		Session.set('admin_subtitle', 'Create New');
		Session.set('admin_collection_page', 'new');
		Session.set('admin_collection_name', collectionName);
		Modal.show("AdminDashboardNewModal", doc)

		$(".admin-dashboard-body").css("max-height", Steedos.getModalMaxHeight());

		$('#admin_new').on('hidden.bs.modal', (e) ->
			if callback
				callback()
		)

	AdminDashboard.modalEdit = (collectionName, id, callback) ->
		Session.set('admin_title', collectionName);
		Session.set('admin_subtitle', 'Edit');
		Session.set('admin_collection_page', 'edit');
		Session.set('admin_collection_name', collectionName);
		Session.set('admin_id', id);
		Meteor.subscribe 'adminCollectionDoc', collectionName, id, ()->
			Modal.allowMultiple = true
			Modal.show("AdminDashboardEditModal")
			Modal.allowMultiple = false
			$(".admin-dashboard-body").css("max-height", Steedos.getModalMaxHeight());

			$('#admin_edit').on('hidden.bs.modal', (e) ->
				if callback
					callback()
			)

	AdminDashboard.modalDelete = (collectionName, id, callback) ->
		swal
			title: TAPi18n.__("flow_db_admin_confirm_delete"),
			text: TAPi18n.__("flow_db_admin_confirm_delete_document"),
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: TAPi18n.__("Delete"),
			cancelButtonText: TAPi18n.__("Cancel"),
			closeOnConfirm: false,
			html: false
		, ()->
			Meteor.call 'adminRemoveDoc', collectionName, id, (error, r)->
				if error
					if error.reason
						toastr.error TAPi18n.__ error.reason
					else
						toastr.error error
				else
					swal 
						title: TAPi18n.__("Delete"),
						text: TAPi18n.__("flow_db_admin_successfully_deleted"),
						type: "success",
						confirmButtonText: TAPi18n.__("OK")
					if callback
						callback()

