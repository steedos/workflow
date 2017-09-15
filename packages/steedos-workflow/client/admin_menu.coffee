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
		url: "/admin/view/flow_roles"
		sort: 20
		parent: "workflow"

	# 岗位成员
	Admin.addMenu
		_id: "flow_positions"
		title: "flow_positions"
		app: "workflow"
		icon: "ion ion-ios-at-outline"
		url: "/admin/workflow/flow_positions"
		sort: 30
		parent: "workflow"

	# 流程设计器
	Admin.addMenu
		_id: "workflow_designer"
		title: "Workflow Designer"
		app: "workflow"
		icon: "ion ion-ios-shuffle"
		url: "/workflow/designer"
		sort: 40
		parent: "workflow"

	# 流程脚本
	Admin.addMenu
		_id: "workflow_form_edit"
		title: "workflow_form_edit"
		app: "workflow"
		icon: "ion ion-ios-paper-outline"
		url: "/admin/flows"
		paid: "true"
		sort: 50
		parent: "workflow"

	# 流程导入导出
	Admin.addMenu
		_id: "workflow_import_export_flows"
		title: "workflow_import_export_flows"
		app: "workflow"
		icon: "ion ion-ios-cloud-download-outline"
		url: "/admin/importorexport/flows"
		paid: "true"
		sort: 50
		parent: "workflow"

	# 图片签名
	Admin.addMenu
		_id: "space_user_signs"
		title: "space_user_signs"
		app: "workflow"
		icon: "ion ion-ios-pulse"
		url: "/admin/view/space_user_signs"
		paid: "true"
		sort: 60
		parent: "workflow"

	# webhook
	Admin.addMenu
		_id: "webhooks"
		title: "webhooks"
		app: "workflow"
		icon: "ion ion-ios-paperplane-outline"
		url: "/admin/view/webhooks"
		paid: "true"
		sort: 70
		parent: "workflow"

	# 流程分类
	Admin.addMenu
		_id: "categories"
		title: "categories"
		app: "workflow"
		icon: "ion ion-ios-folder-outline"
		url: "/admin/categories"
		sort: 45
		parent: "workflow"

	Admin.addMenu
		_id: "instance_number_rules"
		title: "instance_number_rules"
		app: "workflow"
		icon: "ion ion-ios-refresh-outline"
		url: "/admin/instance_number_rules"
		paid: "true"
		sort: 55
		parent: "workflow"
