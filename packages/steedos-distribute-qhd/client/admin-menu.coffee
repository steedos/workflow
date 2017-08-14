if Meteor.isClient
	# 分发设置
	Admin.addMenu
		_id: "distribute_manager"
		title: "distribute_manager"
		app: "workflow"
		icon: "ion ion-ios-browsers-outline"
		url: "/admin/distribute/flows"
		paid: "true"
		sort: 80
		parent: "workflow"
