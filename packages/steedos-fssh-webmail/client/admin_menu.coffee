if Meteor.isClient

	Steedos.addAdminMenu
		_id: "webMailAccount"
		title: "邮件账户"
		parent: "account"
		icon: "ion ion-ios-email-outline"
		sort: 130
		url: "/fssh/mail_account"