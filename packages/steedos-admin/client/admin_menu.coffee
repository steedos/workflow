if Meteor.isClient

	# 账户设置
	Steedos.addAdminMenu
		_id: "account"	
		title: "Account Settings"
		icon: "ion ion-ios-person-outline"
		sort: 10

	# 个人信息
	Steedos.addAdminMenu
		_id: "profile"
		title: "Profile"
		icon:"ion ion-ios-person-outline"
		url: "/admin/profile/profile"
		sort: 10
		parent: "account"

	# 头像
	Steedos.addAdminMenu
		_id: "avatar"
		title: "Avatar"
		icon:"ion ion-ios-camera-outline"
		url: "/admin/profile/avatar"
		sort: 20
		parent: "account"

	# 账户
	Steedos.addAdminMenu
		_id: "account_info"
		title: "Account"
		icon:"ion ion-ios-lightbulb-outline"
		url: "/admin/profile/account"
		sort: 30
		parent: "account"

	# 密码
	Steedos.addAdminMenu
		_id: "password"
		title: "Password"
		icon:"ion ion-ios-locked-outline"
		url: "/admin/profile/password"
		sort: 40
		parent: "account"

	#设置字体
	Steedos.addAdminMenu
		_id: "accountZoom"
		title: "Accountzoom"
		icon:"ion ion-ios-glasses-outline"
		url: "/admin/profile/accountZoom"
		sort: 50
		parent: "account"

	#设置背景
	Steedos.addAdminMenu
		_id: "backgroundImage"
		title: "Backgroundimage"
		icon:"ion ion-ios-color-wand-outline"
		url: "/admin/profile/backgroundImage"
		sort: 60
		parent: "account"

	# 企业设置
	Steedos.addAdminMenu
		_id: "spaces"
		title: "business_settings"
		icon: "ion ion-ios-cloud-outline"
		roles:["space_admin"]
		sort: 20

	# 组织架构
	Steedos.addAdminMenu
		_id: "contacts_organizations"
		title: "contacts_organizations"
		# mobile: false
		icon: "ion ion-ios-people-outline"
		url: "/admin/organizations"
		roles:["space_admin"]
		sort: 10
		parent: "spaces"


	# 企业信息
	Steedos.addAdminMenu
		_id: "space_info"
		title: "business_info"
		icon: "ion ion-ios-world-outline"
		url: "/admin/space/info"
		roles:["space_admin"]
		sort: 20
		parent: "spaces"

	# 订单
	# Steedos.addAdminMenu
	# 	_id: "billing_pay_records"
	# 	title: "billing_pay_records"
	# 	icon: "ion ion-social-usd-outline"
	# 	url: "/admin/view/billing_pay_records"
	# 	roles:["space_admin"]
	# 	sort: 30
	# 	parent: "spaces"

	# 自定义应用
	# Steedos.addAdminMenu
	# 	_id: "steedos_customize_apps"
	# 	title: "business_applications"
	# 	icon: "ion ion-ios-keypad-outline"
	# 	url: "/admin/customize_apps"
	# 	roles:["space_admin"]
	# 	sort: 40
	# 	parent: "spaces"

	# 需配置webservices.creator
	creatorSettings = Meteor.settings.public?.webservices?.creator
	if creatorSettings?.status == "active"
		# 高级设置
		Steedos.addAdminMenu
			_id: "advanced_setting"
			title: "advanced_setting"
			mobile: false
			app: "workflow"
			icon: "ion ion-ios-gear-outline"
			roles: ["space_admin"]
			url: "#"
			onclick: ->
				creatorSettings = Meteor.settings.public?.webservices?.creator
				if creatorSettings?.status == "active"
					url = creatorSettings.url
					reg = /\/$/
					unless reg.test url
						url += "/"
					url = "#{url}app/admin"
					Steedos.openWindow(url)
			sort: 80

	# 通讯录权限
	# Steedos.addAdminMenu
	# 	_id: "steedos_contacts_settings"
	# 	title: "steedos_contacts_settings"
	# 	mobile: false
	# 	icon: "ion ion-ios-people-outline"
	# 	sort: 10
	# 	roles: ["space_admin"]
	# 	url: "/admin/contacts/settings"
	# 	parent: "advanced_setting"

	# 岗位成员
	# Steedos.addAdminMenu
	# 	_id: "flow_positions"
	# 	title: "flow_positions"
	# 	mobile: false
	# 	app: "workflow"
	# 	icon: "ion ion-ios-at-outline"
	# 	url: "/admin/workflow/flow_positions"
	# 	sort: 15
	# 	parent: "advanced_setting"

	# 流程分类
	# Steedos.addAdminMenu
	# 	_id: "categories"
	# 	mobile: false
	# 	title: "categories"
	# 	app: "workflow"
	# 	icon: "ion ion-ios-folder-outline"
	# 	url: "/admin/categories"
	# 	sort: 20
	# 	parent: "advanced_setting"

	# 流程脚本
	# Steedos.addAdminMenu
	# 	_id: "workflow_form_edit"
	# 	title: "workflow_form_edit"
	# 	mobile: false
	# 	app: "workflow"
	# 	icon: "ion ion-ios-paper-outline"
	# 	url: "/admin/flows"
	# 	paid: "true"
	# 	appversion:"workflow_pro"
	# 	sort: 30
	# 	parent: "advanced_setting"

#	# 流程导入导出
#	Steedos.addAdminMenu
#		_id: "workflow_import_export_flows"
#		title: "workflow_import_export_flows"
#		mobile: false
#		app: "workflow"
#		icon: "ion ion-ios-cloud-download-outline"
#		url: "/admin/importorexport/flows"
#		paid: "true"
#		appversion:"workflow_pro"
#		sort: 40
#		parent: "advanced_setting"

	# 流程编号规则
	# Steedos.addAdminMenu
	# 	_id: "instance_number_rules"
	# 	title: "instance_number_rules"
	# 	mobile: false
	# 	app: "workflow"
	# 	icon: "ion ion-ios-refresh-outline"
	# 	url: "/admin/instance_number_rules"
	# 	paid: "true"
	# 	sort: 50
	# 	parent: "advanced_setting"

	# 图片签名
	# Steedos.addAdminMenu
	# 	_id: "space_user_signs"
	# 	title: "space_user_signs"
	# 	mobile: false
	# 	app: "workflow"
	# 	icon: "ion ion-ios-pulse"
	# 	url: "/admin/space_user_signs"
	# 	paid: "true"
	# 	appversion:"workflow_pro"
	# 	sort: 60
	# 	parent: "advanced_setting"

	# Steedos.addAdminMenu
	# 	_id: "secrets"
	# 	title: "API Token"
	# 	mobile: false
	# 	icon:"ion ion-ios-unlocked-outline"
	# 	url: "/admin/api/secrets"
	# 	sort: 70
	# 	parent: "advanced_setting"

	# webhook
	# Steedos.addAdminMenu
	# 	_id: "webhooks"
	# 	title: "webhooks"
	# 	mobile: false
	# 	app: "workflow"
	# 	icon: "ion ion-ios-paperplane-outline"
	# 	url: "/admin/webhooks"
	# 	paid: "true"
	# 	appversion:"workflow_pro"
	# 	sort: 80
	# 	parent: "advanced_setting"
