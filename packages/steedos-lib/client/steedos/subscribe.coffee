Steedos.subsBootstrap = new SubsManager();
Steedos.subsBootstrap.subscribe('userData')
Steedos.subsBootstrap.subscribe('apps')
Steedos.subsBootstrap.subscribe('my_spaces')
Steedos.subsBootstrap.subscribe("steedos_keyvalues")

Tracker.autorun (c)->
	if Steedos.subsBootstrap.ready("my_spaces")
		spaceId = Steedos.getSpaceId()
		Steedos.setSpaceId(spaceId)



Steedos.subsSpace = new SubsManager();

Tracker.autorun (c)->
	spaceId = Session.get("spaceId")
	
	Steedos.subsSpace.reset();
	if spaceId
		Steedos.subsSpace.subscribe("apps", spaceId)
		# Steedos.subsSpace.subscribe("space_users", spaceId)
		# Steedos.subsSpace.subscribe("organizations", spaceId)
		# Steedos.subsSpace.subscribe("flow_roles", spaceId)
		# Steedos.subsSpace.subscribe("flow_positions", spaceId)
					
		Steedos.subsSpace.subscribe("categories", spaceId)
		Steedos.subsSpace.subscribe("forms", spaceId)
		Steedos.subsSpace.subscribe("flows", spaceId)

		Steedos.subsSpace.subscribe("my_space_user", spaceId)
		Steedos.subsSpace.subscribe("my_organizations", spaceId)
		Steedos.subsSpace.subscribe("space_user_signs", spaceId);

Tracker.autorun (c)->
	if Steedos.subsSpace.ready("apps")
		if FlowRouter.current().path == "/"
			firstApp = Steedos.getSpaceFirstApp()
			if firstApp
				Steedos.openApp firstApp._id
			else
				FlowRouter.go("/steedos/springboard")
Meteor.startup ->
	accountZoomValue = {}
	accountZoomValue.name = localStorage.getItem("accountZoomValue.name")
	accountZoomValue.size = localStorage.getItem("accountZoomValue.size")
	Steedos.applyAccountZoomValue accountZoomValue

	accountBgBodyValue = {}
	accountBgBodyValue.url = localStorage.getItem("accountBgBodyValue.url")
	Steedos.applyAccountBgBodyValue accountBgBodyValue

	Tracker.autorun (c)->
		if Steedos.subsBootstrap.ready("steedos_keyvalues")
			accountZoomValue = Steedos.getAccountZoomValue()
			Steedos.applyAccountZoomValue accountZoomValue,true
			
			accountBgBodyValue = Steedos.getAccountBgBodyValue()
			Steedos.applyAccountBgBodyValue accountBgBodyValue,true


Steedos.subsForwardRelated = new SubsManager()

Tracker.autorun (c)->
	space_id = Session.get('forward_space_id')
	Steedos.subsForwardRelated.reset();
	if space_id
		Steedos.subsForwardRelated.subscribe("my_space_user", space_id);
		Steedos.subsForwardRelated.subscribe("my_organizations", space_id);
		Steedos.subsForwardRelated.subscribe("categories", space_id);
		Steedos.subsForwardRelated.subscribe("forms", space_id);
		Steedos.subsForwardRelated.subscribe("flows", space_id);

Tracker.autorun (c)->
	if Session.get("document_title")
		console.log "set document_title"
		$(document).attr("title", Session.get("document_title"));

