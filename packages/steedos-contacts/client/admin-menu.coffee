Meteor.startup ()->
	Admin.addMenu
		_id: "steedos_contacts_settings"
		title: "steedos_contacts_settings"
		mobile: false
		icon: "ion ion-ios-people-outline"
		sort: 50
		roles: ["space_admin"]
		url: "/admin/contacts/settings"