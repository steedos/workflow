Meteor.startup ()->
	
	onclick = (parent, _id) ->
		$(".treeview-menu a[class^='admin-menu-']").removeClass("selected")
		$(".treeview-menu a.admin-menu-#{_id}").addClass("selected")
		unless $(".admin-menu-#{parent}").closest("li").hasClass("active")
				$(".admin-menu-#{parent}").trigger("click")

	# 同步合同台账
	Admin.addMenu
		_id: "records_qhd_sync_contracts"
		title: "records_qhd_sync_contracts_title"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-loop"
		url: "/records_qhd/sync_contracts"
		sort: 2000
		roles: ["space_admin"]
		parent: "advanced_setting"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# 申请单重归档
	Admin.addMenu
		_id: "records_qhd_sync_archive"
		title: "records_qhd_sync_archive_title"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-loop"
		url: "/records_qhd/sync_archive"
		sort: 1900
		roles: ["space_admin"]
		parent: "advanced_setting"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)