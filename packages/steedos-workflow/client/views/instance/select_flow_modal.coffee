Template.selectFlowModal.helpers
	flow_list_data: ->
		if !Steedos.subsForwardRelated.ready()
			return
		WorkflowManager.getFlowListData 'forward'
	empty: (categorie) ->
		if !categorie.forms or categorie.forms.length < 1
			return false
		true
	equals: (a, b) ->
		a == b
	spaces: ->
		db.spaces.find()
	spaceName: ->
		if Session.get('forward_space_id')
			space = db.spaces.findOne(Session.get('forward_space_id'))
			if space
				return space.name
		if Session.get("spaceId")
			space = db.spaces.findOne(Session.get('spaceId'))
			if space
				return space.name
		t 'Steedos'
	showSpaces: ->
		return db.spaces.find().fetch().length != 1

Template.selectFlowModal.events
	'click .dropdown-menu li': (event, template) ->
		space_id = @_id
		Session.set 'forward_space_id', space_id
		return
	'click .flow_list_box .weui_cell': (event, template) ->
		flow = event.currentTarget.dataset.flow
		console.log 'forwardIns flow is ' + flow

		if !flow
			return

		if template.data?.onSelectFlow
			if typeof(template.data.onSelectFlow) == 'function'
				template.data?.onSelectFlow(db.flows.findOne({_id:flow} ,{fields: {_id: 1, name: 1}}));

		Modal.hide 'selectFlow'
		Modal.allowMultiple = false;