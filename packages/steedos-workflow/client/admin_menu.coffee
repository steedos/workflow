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
		icon: "ion ion-university"
		url: "/admin/view/flow_roles"
		sort: 20
		parent: "workflow"

	# 岗位成员
	Admin.addMenu
		_id: "flow_positions"
		title: "flow_positions"
		app: "workflow"
		icon: "ion ion-android-happy"
		url: "/admin/view/flow_positions"
		sort: 30
		parent: "workflow"

	# 流程设计器
	Admin.addMenu
		_id: "workflow_designer"
		title: "Workflow Designer"
		app: "workflow"
		icon: "ion ion-shuffle"
		url: "/workflow/designer"
		sort: 40
		parent: "workflow"

	# 流程脚本
	Admin.addMenu
		_id: "workflow_form_edit"
		title: "workflow_form_edit"
		app: "workflow"
		icon: "ion ion-ios-paper"
		url: "/admin/flows"
		paid: "true"
		sort: 50
		parent: "workflow"

	# 图片签名
	Admin.addMenu
		_id: "space_user_signs"
		title: "space_user_signs"
		app: "workflow"
		icon: "ion ion-images"
		url: "/admin/view/space_user_signs"
		paid: "true"
		sort: 60
		parent: "workflow"

	# webhook
	Admin.addMenu
		_id: "webhooks"
		title: "webhooks"
		app: "workflow"
		icon: "ion ion-link"
		url: "/admin/view/webhooks"
		paid: "true"
		sort: 70
		parent: "workflow"

	# 分发设置
	Admin.addMenu
		_id: "distribute_manager"
		title: "distribute_manager"
		app: "workflow"
		icon: "ion ion-ios-browsers"
		url: "/admin/distribute/flows"
		paid: "true"
		sort: 80
		parent: "workflow"
