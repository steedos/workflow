if Meteor.isClient
	
	onclick = (parent, _id) ->
		$(".treeview-menu a[class^='admin-menu-']").removeClass("selected")
		$(".treeview-menu a.admin-menu-#{_id}").addClass("selected")
		unless $(".admin-menu-#{parent}").closest("li").hasClass("active")
				$(".admin-menu-#{parent}").trigger("click")
	# 分发管理
	Admin.addMenu
		_id: "distribute_manager"
		title: "distribute_manager"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-browsers-outline"
		url: "/admin/distribute/flows"
		paid: "true"
		sort: 90
		parent: "advanced_setting"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)