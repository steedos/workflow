Meteor.startup ()->
	Admin.addMenu
		_id: "steedos_contacts_settings"
		title: t("steedos_contacts_settings")
		icon: "ion ion-ios-people-outline"
		sort: 50
		roles: ["space_admin"]
		url: "/admin/contacts/settings"