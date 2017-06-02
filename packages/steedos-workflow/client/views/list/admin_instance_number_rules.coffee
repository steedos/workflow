Template.admin_instance_number_rules.helpers
	selector: ->
		return {space: Session.get("spaceId")};

	updateButtonContent: ->
		return t("Update");

	insertButtonContent: ->
		return t("Create")

Template.admin_instance_number_rules.events
	'click #create': (event)->
		$('.btn.record-types-create').click();

	'click #edit': (event) ->
		dataTable = $(event.target).closest('table').DataTable();
		rowData = dataTable.row(event.currentTarget.parentNode.parentNode).data();
		if (rowData)
			Session.set 'cmDoc', rowData
			$('.btn.record-types-edit').click();