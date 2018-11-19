if Meteor.isClient

	Steedos.addAdminMenu 
		_id: "sogo"
		title: "Steedos Sogo"
		icon: "ion ion-ios-albums-outline"
		sort: 40

	Steedos.addAdminMenu
		_id: "sogoMailAccount"
		title: "sogo_mail_account"
		parent: "sogo"
		icon: "ion ion-ios-email-outline"
		sort: 130
		url: "/admin/mail_account"