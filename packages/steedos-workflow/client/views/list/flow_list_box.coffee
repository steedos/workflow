Template.flow_list_box.helpers
	flow_list_data: ->
		return WorkflowManager.getFlowListData();

	empty: (categorie)->
		if !categorie.forms || categorie.forms.length < 1
			return false;
		return true;

	equals: (a, b)->
		return a == b;

	is_start_flow: (flowId)->
		start_flows = db.steedos_keyvalues.findOne({space: Session.get("spaceId"), user: Meteor.userId(), key: 'start_flows'})?.value || []

		return start_flows.includes(flowId)

	start_flows: ()->
		start_flows = db.steedos_keyvalues.findOne({space: Session.get("spaceId"), user: Meteor.userId(), key: 'start_flows'})?.value || []
		return db.flows.find({_id: {$in: start_flows}})

	show_start_flows: (start_flows)->
		if start_flows?.count() > 0
			return true
		return false;


Template.flow_list_box.events

	'click .flow_list_box .weui-cell__bd': (event) ->

		flow = event.currentTarget.dataset.flow;

		if !flow
			return;

		Modal.hide('flow_list_box_modal');

		InstanceManager.newIns(flow);

		if Steedos.isMobile()
			# 手机上可能菜单展开了，需要额外收起来
			$("body").removeClass("sidebar-open")

	'click .flow_list_box .weui-cell__ft': (event, template) ->

		start = false
		if event.currentTarget.dataset.start
			start = true

		Meteor.call 'start_flow', Session.get("spaceId"), this._id, !start