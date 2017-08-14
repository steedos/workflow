Template.admin_flows.onRendered ()->
	if !Steedos.isPaidSpace()
		Steedos.spaceUpgradedModal()
		FlowRouter.go("/admin/home")

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