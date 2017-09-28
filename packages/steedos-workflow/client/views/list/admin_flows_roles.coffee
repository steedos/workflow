Template.admin_flow_roles.helpers
	selector: ->
		spaceId = Steedos.spaceId()
		selector = 
			space: spaceId

		return selector

Template.admin_flow_roles.events
	'click .role-edit': (event,template) ->
		roleid = event.currentTarget.dataset.roleid
		flowRole = db.flow_roles.findOne(roleid)
		Modal.show("admin_flows_roles_modal",flowRole)

	'click .role-remove': (event,template) ->
		roleid = event.currentTarget.dataset.roleid
		$(".admin-roles-remove").click()
		swal {
			title: t("Are you sure?"),
			type: "warning",
			showCancelButton: true,
			cancelButtonText: t('Cancel'),
			confirmButtonColor: "#DD6B55",
			confirmButtonText: t('OK'),
			closeOnConfirm: true
		}, () ->
			db.flow_roles.remove {_id:roleid} , (error,result)->
				if result
					toastr.success("删除成功")
				else
					toastr.error(t(error.reason))
				


	'click #create': (event,template) ->
		Session.set "cmDoc",{}
		$(".admin-roles-add").click()