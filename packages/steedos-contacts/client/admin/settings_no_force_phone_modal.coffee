Template.contacts_settings_no_force_phone_modal.helpers
	users_schema: ()->
		fields =
			users:
				autoform:
					type: 'selectuser'
					multiple: true
					defaultValue: ()->
						setting = db.space_settings.findOne({space: Session.get("spaceId"), key: "contacts_no_force_phone_users"})
						return setting?.values || []
				optional: false
				type: [ String ]
				label: ''

		return new SimpleSchema(fields)


Template.contacts_settings_no_force_phone_modal.events
	'click .btn-save': (event, template)->
		Meteor.call("set_space_settings", Session.get("spaceId"), "contacts_no_force_phone_users", AutoForm.getFieldValue("users","contacts_settings_no_force_phone_users"), true, ()->
			Modal.hide(template);
			toastr.success(t("saved_successfully"))
		)