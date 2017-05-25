Template.admin_flows.helpers
	selector: ->
		return {space: Session.get("spaceId"), is_deleted: false};
	updateButtonContent: ->
		return t("Update");

Template.admin_flows.events
	'click #editFlow': (event) ->
		dataTable = $(event.target).closest('table').DataTable();
		rowData = dataTable.row(event.currentTarget.parentNode.parentNode).data();
		if (rowData)
			Session.set 'cmDoc', rowData
			$('.btn.record-types-edit').click();

	'click #importFlow': (event)->
		Modal.show("admin_import_flow_modal");

Template.admin_flows.onRendered ->
	copyTableauUrlClipboard = new Clipboard('#copyTableauUrl');
	copyTableauUrlClipboard.on 'success', (e) ->
		toastr.success(t("instance_readonly_view_url_copy_success"))
		e.clearSelection()