Template.admin_import_flow_modal.helpers
	spaceId: ->
		return Session.get("spaceId");


Template.admin_import_flow_modal.events
	'click #import_flow_ok': (event)->

		if $("#importFlowFile")[0].files.length == 0
			toastr.warning(t("workflow_import_flow_info"))
			return;
		if !Steedos.isLegalVersion('',"workflow.professional")
			Steedos.spaceUpgradedModal()
			return;
		formData = new FormData();

		formData.append('file-0', $("#importFlowFile")[0].files[0]);

		$.ajax
			type:"POST"
			url: Steedos.absoluteUrl("api/workflow/import/form?space=" + Session.get("spaceId"))
			processData: false
			contentType: false
			data: formData
			success: ()->
				toastr.success(t("workflow_import_flow_success"))
				Modal.hide("admin_import_flow_modal")
			error: (e)->
				toastr.error(t("workflow_import_flow_error"));
				console.log e

