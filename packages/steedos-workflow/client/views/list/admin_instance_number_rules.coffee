Template.admin_instance_number_rules.helpers
	selector: ->
		return {space: Session.get("spaceId")};

	updateButtonContent: ->
		return t("Update");

	insertButtonContent: ->
		return t("Create")

	removeButtonContent: ->
		return t("Delete")

	removePrompt: ->
		return t("ConfirmDeletion?");

Template.admin_instance_number_rules.events
	'click #create': (event)->
		$('.btn.record-types-create').click();

	'click #edit': (event) ->
		dataTable = $(event.target).closest('table').DataTable();
		rowData = dataTable.row(event.currentTarget.parentNode.parentNode).data();
		if (rowData)
			Session.set 'cmDoc', rowData
			$('.btn.record-types-edit').click();

	'click #remove': (event) ->
		dataTable = $(event.target).closest('table').DataTable();
		rowData = dataTable.row(event.currentTarget.parentNode.parentNode).data();
		if (rowData)
			Session.set 'cmDoc', rowData
			$('.btn.record-types-remove').click();

Template.admin_instance_number_rules.onRendered ()->
	if !Steedos.isPaidSpace()
		Steedos.spaceUpgradedModal()
		FlowRouter.go("/admin/home")