
Template.contacts_settings.helpers

	hidden_users: ()->

		spaceId = Session.get("spaceId");

		setting = db.space_settings.findOne({space: spaceId, key: "contacts_hidden_users"})

		values = setting?.values || []

		if setting
			return SteedosDataManager.spaceUserRemote.find({space: spaceId, user: {$in: values}}, {fields: {_id: 1, name: 1, user: 1, email: 1}})
		else
			return []



Template.contacts_settings.events
	'click .set_settings': ()->
		Modal.show("contacts_settings_hidden_modal")
