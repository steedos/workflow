Template.remind_modal.helpers
	user_context: ()->
		ins = WorkflowManager.getInstance();
		if !ins
			return false

		users_id = new Array
		users = new Array

		if this.action_types.includes('admin')
			_.each ins.traces, (t)->
				_.each t.approves, (ap)->
					if ap.is_finished isnt true and ap.type isnt 'forward' and ap.type isnt 'distribute'
						if not users_id.includes(ap.user) # 去重
							users_id.push(ap.user)
							users.push {id: ap.user, name: ap.user_name}

		else if this.action_types.includes('applicant')
			last_trace = _.last(ins.traces)
			_.each last_trace.approves, (ap)->
				if ap.is_finished isnt true and ap.type isnt 'cc' and ap.type isnt 'forward' and ap.type isnt 'distribute'
					if not users_id.includes(ap.user) # 去重
						users_id.push ap.user
						users.push {id: ap.user, name: ap.user_name}

			this.trace_id = last_trace._id

		else if this.action_types.includes('cc')
			_.each ins.traces, (t)->
				_.each t.approves, (ap)->
					if ap.is_finished isnt true and ap.type is 'cc' and ap.from_user is Meteor.userId()
						if not users_id.includes(ap.user) # 去重
							users_id.push(ap.user)
							users.push {id: ap.user, name: ap.user_name}

		data = {
			value: users
			dataset: {
				showOrg: false,
				multiple: true,
				userOptions: users_id,
				values: users_id.toString()
			},
			name: 'instance_remind_select_users',
			atts: {
				name: 'instance_remind_select_users',
				id: 'instance_remind_select_users',
				class: 'selectUser form-control'
			}
		}

		return data

	deadline_fields: ()->
		if Steedos.isAndroidOrIOS()
			return new SimpleSchema({
				remind_deadline: {
					autoform: {
						type: "datetime-local"
					},
					optional: true,
					type: Date,
					label: TAPi18n.__('instance_remind_deadline')
				}
			})
		else
			return new SimpleSchema({
				remind_deadline: {
					autoform: {
						type: "bootstrap-datetimepicker"
						dateTimePickerOptions:{
							format: "YYYY-MM-DD HH:mm",
							locale:Session.get("TAPi18n::loaded_lang"),
						}
					},
					optional: true,
					type: Date,
					label: TAPi18n.__('instance_remind_deadline')
				}
			})

	deadline_values: ()->
		return {}

	disabled: ()->
		if not this.action_types.includes("admin")
			return true

		return false

	remind_count_options: ()->
		return [{
			value: "single",
			name: TAPi18n.__("instance_remind_count_options.single"),
			action_types: this.action_types
		}, {
			value: "multi",
			name: TAPi18n.__("instance_remind_count_options.multi"),
			action_types: this.action_types
		}]

	isSingle: (value)->
		if value is 'single'
			return true

		return false


Template.remind_modal.onRendered ()->
	console.log "remind_modal onRendered"
	$("#remind_modal .modal-body").css("max-height", Steedos.getModalMaxHeight())
	
Template.remind_modal.events
	'click #instance_remind_ok': (event, template)->
		values = $("#instance_remind_select_users")[0].dataset.values
		remind_users = if values then values.split(",") else []
		remind_count = ''
		_.each $("[name='remind_count_options']"), (op)->
			if op.checked
				remind_count = op.value

		remind_deadline = AutoForm.getFieldValue("remind_deadline", "instance_remind_deadline")

		if _.isEmpty(remind_users)
			toastr.error TAPi18n.__('instance_remind_need_remind_users')
			return

		if not remind_count
			toastr.error TAPi18n.__('instance_remind_need_remind_count')
			return

		if not remind_deadline
			toastr.error TAPi18n.__('instance_remind_need_remind_deadline')
			return

		action_types = template.data.action_types

		if not action_types.includes("admin") or not remind_count
			remind_count = 'single'

		$("body").addClass("loading")
		Meteor.call 'instance_remind', remind_users, remind_count, remind_deadline, Session.get('instanceId'), action_types, template.data.trace_id || "", (err, result)->
			$("body").removeClass("loading")
			if err
				toastr.error TAPi18n.__(err.reason)
			if result == true
				toastr.success(t("instance_remind_success"))
				Modal.hide template
			return



	