if Meteor.isClient

	onclick = (parent, _id) ->
		$(".treeview-menu a[class^='admin-menu-']").removeClass("selected")
		$(".treeview-menu a.admin-menu-#{_id}").addClass("selected")
		unless $(".admin-menu-#{parent}").closest("li").hasClass("active")
				$(".admin-menu-#{parent}").trigger("click")


	#审批王
	Admin.addMenu
		_id: "workflow"
		title: "Steedos Workflow"
		app: "workflow"
		icon: "ion ion-ios-list-outline"
		roles: ["space_admin"]
		sort: 30

	# 岗位
	Admin.addMenu
		_id: "flow_roles"
		title: "flow_roles"
		app: "workflow"
		icon: "ion ion-ios-grid-view-outline"
		url: "/admin/workflow/flow_roles"
		sort: 20
		parent: "workflow"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)


	# 流程设计器
	Admin.addMenu
		_id: "workflow_designer"
		title: "Workflow Designer"
		app: "workflow"
		icon: "ion ion-ios-shuffle"
		url: "/workflow/designer"
		sort: 40
		parent: "workflow"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)
			if Steedos.isMobile()
				swal({
					title: t("workflow_designer_use_pc"),
					confirmButtonText: t("OK")
				})


	# 统计分析
	Admin.addMenu
		_id: "steedos_tableau"
		title: "steedos_tableau"
		icon: "ion ion-ios-pie-outline"
		sort: 2500
		roles: []
		url: "/tableau/info"
		parent: "workflow"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)
			if Steedos.isMobile()
				swal({
					title: t("workflow_designer_use_pc"),
					confirmButtonText: t("OK")
				})