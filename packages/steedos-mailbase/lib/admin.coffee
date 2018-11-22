db.mail_accounts.adminConfig = 
	icon: "globe"
	color: "blue"
	tableColumns: [
		{name: "email"},
	]
	selector: {owner: -1}
	routerAdmin: "/emailjs"

db.mail_domains.adminConfig = 
	icon: "globe"
	color: "blue"
	tableColumns: [
		{name: "domain"},
	]
	routerAdmin: "/emailjs"


Meteor.startup ->

	@mail_accounts = db.mail_accounts
	AdminConfig?.collections_add
		mail_accounts: db.mail_accounts.adminConfig

	@mail_domains = db.mail_domains
	AdminConfig?.collections_add
		mail_domains: db.mail_domains.adminConfig


if Meteor.isClient
	Meteor.startup ->
		Tracker.autorun ->
			if Meteor.userId()
				AdminTables["mail_accounts"]?.selector = {owner: Meteor.userId()}

	
