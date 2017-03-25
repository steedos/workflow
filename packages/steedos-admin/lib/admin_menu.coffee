if Meteor.isClient
	###
	admin_menus：
	{
		_id: xxx
		title: "Steedos Workflow"
		icon:""
		url: ""
		target: "xx"
		onclick: ->
		app: "workflow"
		paid : true
		roles:["space_admin", "space_owner", "cloud_admin"]
		sort: 30
		parent: parentId
	}
	###
	db.admin_menus = new Meteor.Collection()

	Admin.addMenu = (menu)->
		unless menu
			return false
		unless typeof menu._id == "string"
			return false
		return db.admin_menus.insert menu


	# 账户设置
	Admin.addMenu 
		_id: "account"
		title: "Account Settings"
		icon: "ion ion-android-person"
		sort: 10

	Admin.addMenu 
		_id: "profile"
		title: "Profile"
		icon:"ion ion-android-person"
		url: "/admin/profile/profile"
		sort: 10
		parent: "account"

	Admin.addMenu 
		_id: "avatar"
		title: "Avatar"
		icon:"ion ion-image"
		url: "/admin/profile/avatar"
		sort: 20
		parent: "account"

	Admin.addMenu 
		_id: "account_info"
		title: "Account"
		icon:"ion ion-locked"
		url: "/admin/profile/account"
		sort: 30
		parent: "account"

	Admin.addMenu 
		_id: "email"
		title: "email"
		icon:"ion ion-at"
		url: "/admin/profile/emails"
		sort: 40
		parent: "account"

	Admin.addMenu 
		_id: "personalization"
		title: "personalization"
		icon:"ion ion-wand"
		url: "/admin/profile/personalization"
		sort: 50
		parent: "account"


	# 工作区设置
	Admin.addMenu
		_id: "spaces"
		title: "spaces"
		icon: "ion ion-ios-cloud-outline"
		sort: 20

	Admin.addMenu
		_id: "space_info"
		title: "space_info"
		icon: "ion ion-android-globe"
		url: "/admin/space/info"
		sort: 20
		parent: "spaces"

	Admin.addMenu
		_id: "contacts_organizations"
		title: "contacts_organizations"
		icon: "fa fa-sitemap"
		url: "/admin/organizations"
		roles:["space_admin"]
		sort: 30
		parent: "spaces"

	Admin.addMenu
		_id: "steedos_customize_apps" 
		title: "steedos_customize_apps"
		icon: "ion ion-ios-keypad"
		url: "/admin/customize_apps"
		roles:["space_admin"]
		sort: 40
		parent: "spaces"

	Admin.addMenu
		_id: "billings"
		title: "billings"
		icon: "ion ion-social-usd-outline"
		url: "/admin/view/billings"
		roles:["space_admin"]
		sort: 50
		parent: "spaces"


	#审批王设置
	Admin.addMenu
		_id: "Steedos Workflow"
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
		parent: "Steedos Workflow"

	Admin.addMenu
		_id: "flow_positions"
		title: "flow_positions"
		app: "workflow"
		icon: "ion ion-android-happy"
		url: "/admin/view/flow_positions"
		sort: 30
		parent: "Steedos Workflow"

	Admin.addMenu
		_id: "Workflow Designer"
		title: "Workflow Designer"
		app: "workflow"
		icon: "ion ion-shuffle"
		url: "/packages/steedos_admin/assets/designer/index.html?locale={{locale}}&space={{spaceId}}"
		target: "_blank"
		sort: 40
		parent: "Steedos Workflow"

	Admin.addMenu
		_id: "workflow_form_edit"
		title: "workflow_form_edit"
		app: "workflow"
		icon: "ion ion-ios-paper"
		url: "admin/view/flows_template"
		paid: "true"
		sort: 50
		parent: "Steedos Workflow"

	Admin.addMenu
		_id: "space_user_signs"
		title: "space_user_signs"
		app: "workflow"
		icon: "ion ion-images"
		url: "/admin/view/space_user_signs"
		paid: "true"
		sort: 60
		parent: "Steedos Workflow"


	#test1测试
	Admin.addMenu 
		_id: "test1"
		title: "Account Settings"
		app: "workflow"
		icon: "ion ion-android-person"
		url: "/admin/profile/profile"
		# onclick: ->
		# 	console.log("Hello World")
		# 	return false
		target: "_blank"
		# paid: true
		sort: 40

	#test2测试
	Admin.addMenu 
		_id: "test2"
		title: "email"
		app: "workflow"
		icon: "ion ion-at"
		url: "/admin/profile/profile"
		# onclick: ->
		# 	console.log("Hello World")
		# 	return false
		target: "_blank"
		# paid: true
		sort: 40

