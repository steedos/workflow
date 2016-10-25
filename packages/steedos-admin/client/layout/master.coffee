Template.steedosAdminLayout.onCreated ->
	self = this;

	self.minHeight = new ReactiveVar(
		$(window).height());

	$(window).resize ->
		self.minHeight.set($(window).height());

Template.steedosAdminLayout.onRendered ->

	self = this;
	self.minHeight.set($(window).height());

	$('body').removeClass('fixed');
	$(window).resize();


Template.steedosAdminLayout.helpers 
	minHeight: ->
		return Template.instance().minHeight.get() + 'px'
	
	subsReady: ->
		return Steedos.subsBootstrap.ready()
		
	admin_collection_title: ->
		if Session.get('admin_collection_name')
				return t("" + Session.get('admin_collection_name'))

	enableAdd: ->
		c = Session.get('admin_collection_name')
		if c
			config = AdminConfig.collections[c]
			if config?.disableAdd    
				return false;
		return true

	isAdminRoute: ()->
		path = Session.get("router-path")
		return path?.startsWith "/admin"

	isAdminDetailRoute: ()->
		path = Session.get("router-path")
		#正则匹配"/admin/edit/model-name","/admin/edit/modelname/model-id"
		regEdit = /^\/admin\/edit\/(\b)+/
		#正则匹配"/admin/new/model-name","/admin/new/modelname/model-id"
		regNew = /^\/admin\/new\/(\b)+/
		return regEdit.test(path) || regNew.test(path)

Template.steedosAdminLayout.events
	"click #admin-back": (e, t) ->
		c = Session.get('admin_collection_name')
		if c
			FlowRouter.go "/admin/view/#{c}"  
