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
				label: "姓名"
			mobile: 
				type: String,
				optional: true,
				label: "手机号"
				autoform:
					type: ->
						return "text"
			work_phone:
				type: String,
				label: "固定电话"
				optional: true
			email:
				type: String,
				label: "邮件"
				optional: false
				autoform:
					type: "text"
			organizations:
				type: [String],
				label: "所属部门"
				autoform:
					type: "selectorg"
					multiple: true
					defaultValue: ->
						return []
			manager:
				type: String,
				label: "上级主管"
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
				label: "职务"
				optional: true
			company:
				type: String,
				label: "单位"
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
	"click .contacts-add-user-save": (e,t)->
		doc = AutoForm.getFormValues("addContactsUser")?.insertDoc
		
		# console.log doc
		Meteor.call 'addContactsUser', doc, (error,result) ->
			if error
				toastr.error error.reason
			else
				console.log result
				toastr.success "邀请成功"

		Modal.hide(t)


			
