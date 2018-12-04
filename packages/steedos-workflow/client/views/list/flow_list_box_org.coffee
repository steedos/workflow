Template.flow_list_box_org.helpers
	flow_list_data: ->
		contacts_orgId = Session.get("contacts_orgId")
		return WorkflowManager.getCompanyFlowListData(contacts_orgId)



Template.flow_list_box_org.events

	'click .flow_list_box_org .weui-cell__bd': (event) ->

		flow = event.currentTarget.dataset.flow;

		if !flow
			return;

		Modal.hide('flow_list_box_org_modal');

		InstanceManager.newIns(flow);

		if Steedos.isMobile()
			# 手机上可能菜单展开了，需要额外收起来
			$("body").removeClass("sidebar-open")
