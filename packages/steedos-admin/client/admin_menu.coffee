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
		icon: "ion ion-ios-person-outline"
		sort: 10

	# 个人信息
	Admin.addMenu
		_id: "profile"
		title: "Profile"
		icon:"ion ion-ios-person-outline"
		url: "/admin/profile/profile"
		sort: 10
		parent: "account"

	# 头像
	Admin.addMenu
		_id: "avatar"
		title: "Avatar"
		icon:"ion ion-ios-camera-outline"
		url: "/admin/profile/avatar"
		sort: 20
		parent: "account"

	# 账户
	Admin.addMenu
		_id: "account_info"
		title: "Account"
		icon:"ion ion-ios-locked-outline"
		url: "/admin/profile/account"
		sort: 30
		parent: "account"

	# 邮件
	Admin.addMenu
		_id: "email"
		title: "email"
		icon:"ion ion-ios-email-outline"
		url: "/admin/profile/emails"
		sort: 40
		parent: "account"

	# 个性化
	Admin.addMenu
		_id: "personalization"
		title: "personalization"
		icon:"ion ion-ios-color-wand-outline"
		url: "/admin/profile/personalization"
		sort: 50
		parent: "account"

	# API
	Admin.addMenu
		_id: "api"
		title: "Developer"
		icon:"ion ion-ios-loop"
		sort: 60

	# 密钥
	Admin.addMenu
		_id: "secrets"
		title: "API Token"
		icon:"ion ion-ios-unlocked-outline"
		url: "/admin/api/secrets"
		sort: 10
		parent: "api"



	# 工作区
	Admin.addMenu
		_id: "spaces"
		title: "spaces"
		icon: "ion ion-ios-cloud-outline"
		roles:["space_admin"]
		sort: 20

	# 工作区信息
	Admin.addMenu
		_id: "space_info"
		title: "space_info"
		icon: "ion ion-ios-world-outline"
		url: "/admin/space/info"
		roles:["space_admin"]
		sort: 20
		parent: "spaces"

	# 组织架构
	Admin.addMenu
		_id: "contacts_organizations"
		title: "contacts_organizations"
		icon: "ion ion-ios-people-outline"
		url: "/admin/organizations"
		roles:["space_admin"]
		sort: 30
		parent: "spaces"

	# 自定义应用
	Admin.addMenu
		_id: "steedos_customize_apps"
		title: "steedos_customize_apps"
		icon: "ion ion-ios-keypad-outline"
		url: "/admin/customize_apps"
		roles:["space_admin"]
		sort: 40
		parent: "spaces"

	# # 财务
	# Admin.addMenu
	# 	_id: "billings"
	# 	title: "billings"
	# 	icon: "ion ion-social-usd-outline"
	# 	url: "/admin/view/billings"
	# 	roles:["space_admin"]
	# 	sort: 50
	# 	parent: "spaces"
