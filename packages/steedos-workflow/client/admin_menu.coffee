if Meteor.isClient

	#审批王设置
	Admin.addMenu
		_id: "workflow"
		title: "Steedos Workflow"
		app: "workflow"
		icon: "ion ion-ios-list-outline"
		roles: ["space_admin"]
		sort: 30

	Admin.addMenu
		_id: "flow_roles"
		title: "flow_roles"
		app: "workflow"
		icon: "ion ion-university"
		url: "/admin/view/flow_roles"
		sort: 20
		parent: "workflow"

	Admin.addMenu
		_id: "flow_positions"
		title: "flow_positions"
		app: "workflow"
		icon: "ion ion-android-happy"
		url: "/admin/view/flow_positions"
		sort: 30
		parent: "workflow"

	Admin.addMenu
		_id: "Workflow Designer"
		title: "Workflow Designer"
		app: "workflow"
		icon: "ion ion-shuffle"
		url: "/packages/steedos_admin/assets/designer/index.html?locale={{locale}}&space={{spaceId}}"
		target: "_blank"
		sort: 40
		parent: "workflow"

	Admin.addMenu
		_id: "workflow_form_edit"
		title: "workflow_form_edit"
		app: "workflow"
		icon: "ion ion-ios-paper"
		url: "admin/view/flows_template"
		paid: "true"
		sort: 50
		parent: "workflow"

	Admin.addMenu
		_id: "space_user_signs"
		title: "space_user_signs"
		app: "workflow"
		icon: "ion ion-images"
		url: "/admin/view/space_user_signs"
		paid: "true"
		sort: 60
		parent: "workflow"
