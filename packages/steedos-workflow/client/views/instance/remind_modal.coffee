Template.remind_modal.helpers
	select_user_fields: ()->
		return new SimpleSchema({
			remind_users: {
				autoform: {
					type: "selectuser",
					multiple: true,
					spaceId: Session.get('spaceId')
				},
				optional: true,
				type: [String],
				label: TAPi18n.__('instance_remind_select_users')
			}
		})

	select_user_values: ()->
		return {}

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
							format: "YYYY-MM-DD HH:mm"
						}
					},
					optional: true,
					type: Date,
					label: TAPi18n.__('instance_remind_deadline')
				}
			})

	deadline_values: ()->
		return {}

Template.remind_modal.onRendered ()->
	console.log "remind_modal onRendered"
	$("#remind_modal .modal-body").css("max-height", Steedos.getModalMaxHeight())
	
Template.remind_modal.events
	'click #instance_remind_ok': (event, template)->
		remind_users = AutoForm.getFieldValue("remind_users", "instance_remind_select_user")
		remind_count = $('#instance_remind_count').val()
		remind_deadline = AutoForm.getFieldValue("remind_deadline", "instance_remind_deadline")

		$("body").addClass("loading")
		Meteor.call 'instance_remind', remind_users, parseInt(remind_count), remind_deadline, Session.get('instanceId'), (err, result)->
			$("body").removeClass("loading")
			if err
				toastr.error TAPi18n.__(err.reason)
			if result == true
				toastr.success(t("instance_remind_success"))
				Modal.hide template
			return



	