Meteor.startup ()->
	Admin.addMenu
		_id: "steedos_contacts_settings"
		title: t("steedos_contacts_settings")
		icon: "fa fa-sitemap"
		sort: 2500
		roles: ["space_admin"]
		url: "/admin/contacts/settings"