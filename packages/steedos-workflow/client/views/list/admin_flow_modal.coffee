Template.admin_flow_modal.helpers
	doc: ->
		return Template.instance().data


Template.admin_flow_modal.onRendered ->
	$(".admin_flow_modal .modal-body").css("max-height", Steedos.getModalMaxHeight())

Template.admin_flow_modal.events
	'click .save-flow': (event, template)->
		data = template.data

		form_value = AutoForm.getFormValues("admin_flow");

		print_template = form_value.insertDoc.print_template

		instance_template = form_value.insertDoc.instance_template

		events = form_value.insertDoc.events

		field_map = form_value.insertDoc.field_map

		db.flows.update {_id: data._id}, {$set: {print_template: print_template, instance_template: instance_template, events: events, field_map: field_map}},(error,result) ->
			if result
				toastr.success t("flow_roles_update_success")
			else
				toastr.error t(error.reason)

		Modal.hide(template)

	'click .export-table-template': (event, template)->
		data = template.data
		window.open("/api/workflow/export/talbe_template?flow=#{data._id}")

