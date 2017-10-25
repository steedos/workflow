Template.steedos_contacts_add_user_modal.helpers
	fields: ->
		modalFields = 
			space:
				type: String,
				autoform:
					type: "hidden",
					defaultValue: ->
						return Session.get("spaceId");
			name:
				type: String,
				max: 50,
				label: t("space_users_name")
			mobile: 
				type: String,
				optional: true,
				label: t("space_users_mobile")
				autoform:
					type: ->
						return "text"
			email:
				type: String,
				label: t("space_users_email")
				optional: true
				autoform:
					type: "text"
			work_phone:
				type: String,
				label: t("space_users_work_phone")
				optional: true
			organizations:
				type: [String],
				label: t("space_users_organizations")
				autoform:
					type: "selectorg"
					multiple: true
					defaultValue: ->
						return []
			manager:
				type: String,
				label: t("space_users_manager")
				optional: true,
				autoform:
					type: "selectuser"
			user_accepted:
				type: Boolean,
				optional: true,
				autoform:
					type: "hidden"
					defaultValue: true
			position:
				type: String,
				label: t("space_users_position")
				optional: true
			company:
				type: String,
				label: t("space_users_company")
				optional: true
			invite_state:
				type: String
				autoform:
					type: "hidden"
					defaultValue: "pending"
			created:
				type: Date,
				optional: true
				autoform:
					omit: true
			created_by:
				type: String,
				optional: true
				autoform:
					omit: true
			modified:
				type: Date,
				optional: true
				autoform:
					omit: true
			modified_by:
				type: String,
				optional: true
				autoform:
					omit: true

		new SimpleSchema(modalFields)

	values: ->
		return {}

Template.steedos_contacts_add_user_modal.events
	"click .contacts-add-user-save": (event,template)->
		unless AutoForm.validateForm("addContactsUser")
			return
		unless AutoForm.getFieldValue("mobile","addContactsUser") and AutoForm.getFieldValue("email","addContactsUser")
			$('input[data-schema-key="mobile"]').after('<span class="help-block">手机和邮箱不能同时为空</span>')
			$('input[data-schema-key="mobile"]').closest(".form-group").addClass("has-error")
			return
		doc = AutoForm.getFormValues("addContactsUser")?.insertDoc
		
		# console.log doc
		Meteor.call 'addContactsUser', doc, (error,result) ->
			if error
				toastr.error t(error.reason)
			else
				console.log result
				toastr.success t(result)
				Modal.hide(template)


			
