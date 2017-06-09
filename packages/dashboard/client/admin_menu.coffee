if Meteor.isClient

	# 门户
	Admin.addMenu 
		_id: "dashboard"
		title: "Steedos Dashboard"
		icon: "ion ion-ios-albums-outline"
		app: "dashboard"
		sort: 40

	# 面板
	Admin.addMenu 
		_id: "portal_dashboards"
		title: "portal_dashboards"
		icon:"ion ion-ios-photos"
		url: "/admin/view/portal_dashboards"
		roles:["space_admin"]
		sort: 10
		parent: "dashboard"