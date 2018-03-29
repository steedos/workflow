if Meteor.isClient

	# Portal菜单暂时先放到FSSH中，以后需要公开再迁移到Portal中
	# 门户
	Steedos.addAdminMenu 
		_id: "portal"
		title: "Steedos Portal"
		icon: "ion ion-ios-albums-outline"
		app: "portal"
		sort: 40

	# 面板
	Steedos.addAdminMenu 
		_id: "portal_dashboards"
		title: "portal_dashboards"
		icon:"ion ion-ios-photos"
		url: "/admin/view/portal_dashboards"
		roles:["space_admin"]
		sort: 10
		parent: "portal"

	# FSSH为Portal增加的菜单
	# 验证域
	Steedos.addAdminMenu 
		_id: "apps_auths"
		title: "apps_auths"
		icon:"ion ion-aperture"
		url: "/admin/view/apps_auths"
		roles:["space_admin"]
		sort: 100
		parent: "portal"

	#域账户
	Steedos.addAdminMenu 
		_id: "apps_auth_users"
		title: "apps_auth_users"
		icon:"ion ion-ios-personadd"
		url: "/admin/view/apps_auth_users"
		onclick: ->
			Modal.show("accounts_guide_modal")
			return false
		sort: 110
		parent: "portal"

	#邮件域
	Steedos.addAdminMenu 
		_id: "mail_domains"
		title: "mail_domains"
		icon:"ion ion-ios-email"
		url: "/admin/view/mail_domains"
		roles:["cloud_admin"]
		sort: 120
		parent: "portal"