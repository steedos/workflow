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

	# 个人信息
	Admin.addMenu
		_id: "profile"
		title: "Profile"
		icon:"ion ion-android-person"
		url: "/admin/profile/profile"
		sort: 10
		parent: "account"

	# 头像
	Admin.addMenu
		_id: "avatar"
		title: "Avatar"
		icon:"ion ion-image"
		url: "/admin/profile/avatar"
		sort: 20
		parent: "account"

	# 账户
	Admin.addMenu
		_id: "account_info"
		title: "Account"
		icon:"ion ion-locked"
		url: "/admin/profile/account"
		sort: 30
		parent: "account"

	# 邮件
	Admin.addMenu
		_id: "email"
		title: "email"
		icon:"ion ion-at"
		url: "/admin/profile/emails"
		sort: 40
		parent: "account"

	# 个性化
	Admin.addMenu
		_id: "personalization"
		title: "personalization"
		icon:"ion ion-wand"
		url: "/admin/profile/personalization"
		sort: 50
		parent: "account"



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
		icon: "ion ion-android-globe"
		url: "/admin/space/info"
		roles:["space_admin"]
		sort: 20
		parent: "spaces"

	# 组织架构
	Admin.addMenu
		_id: "contacts_organizations"
		title: "contacts_organizations"
		icon: "fa fa-sitemap"
		url: "/admin/organizations"
		roles:["space_admin"]
		sort: 30
		parent: "spaces"

	# 自定义应用
	Admin.addMenu
		_id: "steedos_customize_apps"
		title: "steedos_customize_apps"
		icon: "ion ion-ios-keypad"
		url: "/admin/customize_apps"
		roles:["space_admin"]
		sort: 40
		parent: "spaces"

	# 财务
	Admin.addMenu
		_id: "billings"
		title: "billings"
		icon: "ion ion-social-usd-outline"
		url: "/admin/view/billings"
		roles:["space_admin"]
		sort: 50
		parent: "spaces"
