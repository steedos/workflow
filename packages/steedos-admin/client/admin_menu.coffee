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
		mobile: true
		roles:["space_admin", "space_owner", "cloud_admin"]
		sort: 30
		parent: parentId
	}
	### 
	# 添加左侧菜单的选中效果
	onclick = (parent, _id) ->
		$(".treeview-menu a[class^='admin-menu-']").removeClass("selected")
		$(".treeview-menu a.admin-menu-#{_id}").addClass("selected")
		unless $(".admin-menu-#{parent}").closest("li").hasClass("active")
				$(".admin-menu-#{parent}").trigger("click")


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
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# 头像
	Admin.addMenu
		_id: "avatar"
		title: "Avatar"
		icon:"ion ion-ios-camera-outline"
		url: "/admin/profile/avatar"
		sort: 20
		parent: "account"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# 账户
	Admin.addMenu
		_id: "account_info"
		title: "Account"
		icon:"ion ion-ios-lightbulb-outline"
		url: "/admin/profile/account"
		sort: 30
		parent: "account"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# 密码
	Admin.addMenu
		_id: "password"
		title: "Password"
		icon:"ion ion-ios-locked-outline"
		url: "/admin/profile/password"
		sort: 40
		parent: "account"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	#设置字体
	Admin.addMenu
		_id: "accountZoom"
		title: "Accountzoom"
		icon:"ion ion-ios-glasses-outline"
		url: "/admin/profile/accountZoom"
		sort: 50
		parent: "account"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	#设置背景
	Admin.addMenu
		_id: "backgroundImage"
		title: "Backgroundimage"
		icon:"ion ion-ios-color-wand-outline"
		url: "/admin/profile/backgroundImage"
		sort: 60
		parent: "account"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# 企业设置
	Admin.addMenu
		_id: "spaces"
		title: "business_settings"
		icon: "ion ion-ios-cloud-outline"
		roles:["space_admin"]
		sort: 20

	# 组织架构
	Admin.addMenu
		_id: "contacts_organizations"
		title: "contacts_organizations"
		# mobile: false
		icon: "ion ion-ios-people-outline"
		url: "/admin/organizations"
		roles:["space_admin"]
		sort: 10
		parent: "spaces"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)


	# 企业信息
	Admin.addMenu
		_id: "space_info"
		title: "business_info"
		icon: "ion ion-ios-world-outline"
		url: "/admin/space/info"
		roles:["space_admin"]
		sort: 20
		parent: "spaces"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# 订单
	# Admin.addMenu
	# 	_id: "billing_pay_records"
	# 	title: "billing_pay_records"
	# 	icon: "ion ion-social-usd-outline"
	# 	url: "/admin/view/billing_pay_records"
	# 	roles:["space_admin"]
	# 	sort: 30
	# 	parent: "spaces"

	# 自定义应用
	Admin.addMenu
		_id: "steedos_customize_apps"
		title: "business_applications"
		icon: "ion ion-ios-keypad-outline"
		url: "/admin/customize_apps"
		roles:["space_admin"]
		sort: 40
		parent: "spaces"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# 高级设置
	Admin.addMenu
		_id: "advanced_setting"
		title: "advanced_setting"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-gear-outline"
		roles: ["space_admin"]
		sort: 40

	# 通讯录权限
	Admin.addMenu
		_id: "steedos_contacts_settings"
		title: "steedos_contacts_settings"
		mobile: false
		icon: "ion ion-ios-people-outline"
		sort: 10
		roles: ["space_admin"]
		url: "/admin/contacts/settings"
		parent: "advanced_setting"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# 岗位成员
	Admin.addMenu
		_id: "flow_positions"
		title: "flow_positions"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-at-outline"
		url: "/admin/workflow/flow_positions"
		sort: 15
		parent: "advanced_setting"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# 流程分类
	Admin.addMenu
		_id: "categories"
		mobile: false
		title: "categories"
		app: "workflow"
		icon: "ion ion-ios-folder-outline"
		url: "/admin/categories"
		sort: 20
		parent: "advanced_setting"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# 流程脚本
	Admin.addMenu
		_id: "workflow_form_edit"
		title: "workflow_form_edit"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-paper-outline"
		url: "/admin/flows"
		paid: "true"
		appversion:"workflow_pro"
		sort: 30
		parent: "advanced_setting"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

#	# 流程导入导出
#	Admin.addMenu
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
#		onclick: ->
#			parent = this.parent
#			id = this._id
#			onclick(parent, id)

	# 流程编号规则
	Admin.addMenu
		_id: "instance_number_rules"
		title: "instance_number_rules"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-refresh-outline"
		url: "/admin/instance_number_rules"
		paid: "true"
		sort: 50
		parent: "advanced_setting"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# 图片签名
	Admin.addMenu
		_id: "space_user_signs"
		title: "space_user_signs"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-pulse"
		url: "/admin/space_user_signs"
		paid: "true"
		appversion:"workflow_pro"
		sort: 60
		parent: "advanced_setting"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	Admin.addMenu
		_id: "secrets"
		title: "API Token"
		mobile: false
		icon:"ion ion-ios-unlocked-outline"
		url: "/admin/api/secrets"
		sort: 70
		parent: "advanced_setting"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)

	# webhook
	Admin.addMenu
		_id: "webhooks"
		title: "webhooks"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-paperplane-outline"
		url: "/admin/view/webhooks"
		paid: "true"
		appversion:"workflow_pro"
		sort: 80
		parent: "advanced_setting"
		onclick: ->
			parent = this.parent
			id = this._id
			onclick(parent, id)
