Template.flow_list_box.helpers
	flow_list_data: ->
		showType = Template.instance().data?.showType
		return WorkflowManager.getFlowListData(showType);

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

		can_add_flows = WorkflowManager.getMyCanAddFlows() || []

		flows = db.flows.find({_id: {$in: _.intersection(start_flows, can_add_flows)}})

		return flows

	show_start_flows: (start_flows)->
		if start_flows?.count() > 0
			return true
		return false;
	
	subtitle: ->
		return Template.instance().data?.subTitle
	
	clearable: ->
		return Template.instance().data?.clearable
		
	isCategorieChecked: (id)->
		if Template.instance().data?.categorie == id
			return true
		return false; 

	isFlowChecked: (id, isStar)->
		if Template.instance().data?.flow == id
			return true
		return false; 

Template.flow_list_box.events
	'click .flow_list_box .weui-cell__bd': (event, template) ->
		flow = event.currentTarget.dataset.flow
		clearable = template.data?.clearable
		if !flow and !clearable
			return;
		Modal.hide('flow_list_box_modal');
		categorie = $(event.currentTarget).closest(".collapse").data("categorie")
		if template.data?.callBack && _.isFunction(template.data.callBack)
			template.data.callBack flow:flow, categorie: categorie
		if Steedos.isMobile()
			# 手机上可能菜单展开了，需要额外收起来
			$("body").removeClass("sidebar-open")

	'click .flow_list_box .weui-cell__ft': (event, template) ->

		start = false
		if event.currentTarget.dataset.start
			start = true

		Meteor.call 'start_flow', Session.get("spaceId"), this._id, !start