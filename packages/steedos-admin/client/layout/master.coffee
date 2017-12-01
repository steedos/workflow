Template.adminLayout.helpers 
	
	subsReady: ->
		return Steedos.subsBootstrap.ready() and Steedos.subsSpace.ready()
		
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
		return (path.startsWith("/admin/new/") || path.startsWith("/admin/edit/") || path.startsWith("/admin/view/"))

	isAdminDetailRoute: ()->
		path = Session.get("router-path")
		#正则匹配"/admin/edit/model-name","/admin/edit/modelname/model-id"
		regEdit = /^\/admin\/edit\/(\b)+/
		#正则匹配"/admin/new/model-name","/admin/new/modelname/model-id"
		regNew = /^\/admin\/new\/(\b)+/
		return regEdit.test(path) || regNew.test(path)

	isPayRecords: () ->
		if Session.get('admin_collection_name') == "billing_pay_records"
			return true
		else
			return false

Template.adminLayout.events
	"click #admin-back": (e, t) ->
		c = Session.get('admin_collection_name')
		if c
			FlowRouter.go "/admin/view/#{c}"  
