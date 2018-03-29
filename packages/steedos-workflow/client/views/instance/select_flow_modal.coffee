Template.selectFlowModal.helpers
	flow_list_data: ->
		if !Steedos.subsForwardRelated.ready()
			return
		console.log this
		WorkflowManager.getFlowListData this.action_type, Session.get('space_drop_down_selected_value')
	empty: (categorie) ->
		if !categorie.forms or categorie.forms.length < 1
			return false
		true
	equals: (a, b) ->
		a == b
	spaces: ->
		db.spaces.find()

	showSpaces: ->
		curret_step = InstanceManager.getDistributeStep()
		if curret_step && curret_step.allowDistribute is true && curret_step.distribute_optional_flows && curret_step.distribute_optional_flows.length > 0
			return false

		return db.spaces.find().count() != 1

	selected: (space_id)->
		if Session.get('space_drop_down_selected_value') is space_id
			return true

		return false

Template.selectFlowModal.onRendered ()->
	if (!Session.get('space_drop_down_selected_value'))
		Session.set('space_drop_down_selected_value', Session.get('spaceId'))
	curret_step = InstanceManager.getDistributeStep()
	if curret_step && curret_step.allowDistribute is true && curret_step.distribute_optional_flows
		Session.set('distribute_optional_flows', curret_step.distribute_optional_flows)

Template.selectFlowModal.events
	'change #space_drop_down_box': (event, template) ->
		console.log "space_drop_down_box"
		Session.set('space_drop_down_selected_value', $('#space_drop_down_box').val())
		return
	'click .flow_list_box .weui_cell': (event, template) ->
		flow = event.currentTarget.dataset.flow

		if !flow
			return

		if template.data?.onSelectFlow
			if typeof(template.data.onSelectFlow) == 'function'
				template.data?.onSelectFlow(db.flows.findOne({_id:flow} ,{fields: {_id: 1, name: 1, space: 1, distribute_optional_users: 1, distribute_to_self: 1}}));

		Modal.hide 'selectFlow'
		Modal.allowMultiple = false;

	'hide.bs.modal #selectFlowModal': (event, template) ->
		Modal.allowMultiple = false;
		return true;
