Template.contacts_settings.helpers

	hidden_users: ()->

		spaceId = Session.get("spaceId");

		setting = db.space_settings.findOne({space: spaceId, key: "contacts_hidden_users"})

		values = setting?.values || []

		if setting
			return SteedosDataManager.spaceUserRemote.find({space: spaceId, user: {$in: values}}, {fields: {_id: 1, name: 1, user: 1, email: 1}})
		else
			return []

	view_limits: ()->
		spaceId = Steedos.spaceId()
		return db.space_settings.find(space: spaceId, key: "contacts_view_limits")

	limit_from_names: (froms)->
		orgs = SteedosDataManager.organizationRemote.find _id: {$in: froms}, {fields:{name:1}}
		return orgs.getProperty("name")


Template.contacts_settings.events
	'click .set_settings': (event, template)->
		Modal.show("contacts_settings_hidden_modal")

	'click .view-limit-block .btn-add': (event, template)->
		Modal.show("contacts_settings_limit_modal")

	'click .view-limit-block .btn-edit': (event, template)->
		index = event.currentTarget.dataset.index
		Modal.show("contacts_settings_limit_modal", index)

	'click .view-limit-block .btn-delete': (event, template)->
		Modal.show("contacts_settings_limit_modal")

Template.contacts_settings.onCreated ->
	spaceId = Steedos.spaceId()
	Steedos.subs["contacts_settings"].subscribe("contacts_view_limits", spaceId)

Template.contacts_settings.onDestroyed ->
	Steedos.subs["contacts_settings"].clear()
