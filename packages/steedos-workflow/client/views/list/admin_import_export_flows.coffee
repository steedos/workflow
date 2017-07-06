Template.admin_import_export_flows.helpers
	selector: ->
		return {space: Session.get("spaceId"), is_deleted: false};
	updateButtonContent: ->
		return t("Update");

Template.admin_import_export_flows.events
	'click #importFlow': (event)->
		Modal.show("admin_import_flow_modal");
