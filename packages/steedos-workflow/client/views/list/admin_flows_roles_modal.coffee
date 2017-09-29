Template.admin_flows_roles_modal.onRendered ->
	$(".admin-flows-roles-modal .modal-body").css("max-height" , Steedos.getModalMaxHeight())

Template.admin_flows_roles_modal.helpers
	selector: ->
		data = Template.instance().data
		selector = 
			space: data.space
			role: data._id
		return selector

	doc: ->
		return Template.instance()?.data

Template.admin_flows_roles_modal.events

	'click .datatable-flows-roles tbody tr': (event,template) ->
		Session.set "position-action","edit"
		dataTable = $(event.currentTarget).closest('table').DataTable()
		rowData = dataTable.row(event.currentTarget).data()
		if rowData
			Modal.allowMultiple =true
			Modal.show("admin_flows_roles_detail_modal",rowData)

	'click .add-positions': (event,template) ->
		Session.set "position-action","add"
		data = 
			role: Template.instance()?.data?._id
		Modal.allowMultiple =true
		Modal.show("admin_flows_roles_detail_modal",data)
	
	'click .save-role': (event,template) ->
		roleName = AutoForm.getFieldValue("name","flowRoles")
		if roleName
			roleId = Template.instance().data?._id
			if roleId
				data =
					_id: roleId
					name: roleName
				Meteor.call "updateFlowRole", data,
					(error,result) ->
						if error
							console.log error
						else
							toastr.success t("flow_roles_update_success")	
							Modal.hide(template)	
		else
			toastr.error t("flow_roles_necessary")	