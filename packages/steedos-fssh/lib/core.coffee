FSSH = 
	checkAccount: (userAuth, callback)->
		try
			if !AccountManager.getMailDomain(userAuth.user)
				callback {reason:'账户验证失败, 无效的邮件域名'},false
				return
			imapClient = ImapClientManager.getClient(userAuth)
			pro = imapClient.connect()
			pro.then ->
				imapClient.close()
				callback null,true
			pro.catch (err) ->
				imapClient.close()
				callback {reason:'账户验证失败'},false
		catch e
			callback {reason:'账户验证失败',message:e.message},false


if Meteor.isClient

	# FSSH为Portal增加在steedos-admin中的菜单
	Admin.addMenu 
		_id: "apps_auths"
		title: "apps_auths"
		icon:"ion ion-aperture"
		url: "/admin/view/apps_auths"
		roles:["space_admin"]
		sort: 100
		parent: "portal"

	Admin.addMenu 
		_id: "apps_auth_users"
		title: "apps_auth_users"
		icon:"ion ion-ios-personadd"
		url: "/admin/view/apps_auth_users"
		onclick: ->
			Modal.show("accounts_guide_modal")
			return false
		sort: 110
		parent: "portal"

	Admin.addMenu 
		_id: "mail_domains"
		title: "mail_domains"
		icon:"ion ion-ios-email"
		url: "/admin/view/mail_domains"
		roles:["cloud_admin"]
		sort: 120
		parent: "portal"