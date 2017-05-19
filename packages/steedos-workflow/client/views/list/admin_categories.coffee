Template.admin_categories.helpers
	selector: ->
		return {space: Session.get("spaceId")};

	updateButtonContent: ->
		return t("Update");

Template.admin_categories.events
	'click #editFlow': (event) ->
		dataTable = $(event.target).closest('table').DataTable();
		rowData = dataTable.row(event.currentTarget.parentNode.parentNode).data();
		if (rowData)
			Session.set 'cmDoc', rowData
			$('.btn.record-types-edit').click();