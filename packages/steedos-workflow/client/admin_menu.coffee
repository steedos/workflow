if Meteor.isClient

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

	# 流程设计器
	Admin.addMenu
		_id: "workflow_designer"
		title: "Workflow Designer"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-shuffle"
		url: "/workflow/designer"
		sort: 40
		parent: "workflow"

	# 统计分析
	Admin.addMenu
		_id: "steedos_tableau"
		title: "steedos_tableau"
		icon: "ion ion-ios-pie-outline"
		mobile: false
		sort: 2500
		roles: []
		url: "/tableau/info"
		parent: "workflow"
