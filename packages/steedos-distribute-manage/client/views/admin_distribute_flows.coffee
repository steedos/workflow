Template.admin_distribute_flows.helpers
	selector: ->
		return {space: Session.get("spaceId"), is_deleted: false};

Template.admin_distribute_flows.events
	'click #distribute_edit_flow': (event) ->
		dataTable = $(event.target).closest('table').DataTable();
		rowData = dataTable.row(event.currentTarget.parentNode.parentNode).data();
		if (rowData)
			param = {flow: rowData}
			Modal.show "distribute_edit_flow_modal", param

