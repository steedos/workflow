Template.admin_flows_roles_modal.onRendered ->
	Tracker.autorun (c) ->
		if $(".datatable-flows-roles").length
			table = $(".datatable-flows-roles").DataTable()
			table.column(0)?.visible(false)
			table.column(3)?.visible(false)
			table.column(4)?.visible(false)

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
	# 'click #edit': (event,template) ->
	# 	dataTable = $(event.target).closest('table').DataTable();
	# 	rowData = dataTable.row(event.currentTarget.parentNode.parentNode).data();
	# 	if rowData
	# 		Session.set "cmDoc",rowData
	# 		$(".flows-roles-edit").click()
	# 		$(".flows-roles").closest(".modal").css("background","transparent")

	# 'click #remove': (event,template) ->
	# 	dataTable = $(event.target).closest('table').DataTable();
	# 	rowData = dataTable.row(event.currentTarget.parentNode.parentNode).data();
	# 	if rowData
	# 		Session.set "cmDoc",rowData
	# 		$(".flows-roles-remove").click()
	# 		$(".flows-roles").closest(".modal").css("background","transparent")

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
							toastr.success "更新成功"	
							Modal.hide(template)	
		else
			toastr.error("请填写岗位名称")	