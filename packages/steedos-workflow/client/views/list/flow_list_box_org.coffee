Template.flow_list_box_org.helpers
	flow_list_data: ->
		flow_list_box_org_id = Session.get("flow_list_box_org_id")
		if flow_list_box_org_id
			return WorkflowManager.getCompanyFlowListData(flow_list_box_org_id)
		else
			return {}



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
