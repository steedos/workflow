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

Tracker.autorun (c)->
	if Steedos.subsBootstrap.ready("steedos_keyvalues")
		accountZoomValue = Steedos.getAccountZoomValue()
		if accountZoomValue.name
			if SC.browser.isiOS
				if accountZoomValue.size
					$("meta[name=viewport]").attr("content","initial-scale=#{accountZoomValue.size}, user-scalable=no")
				else
					$("meta[name=viewport]").attr("content","initial-scale=1, user-scalable=no")
			else
				$("body").removeClass("zoom-normal").removeClass("zoom-large").removeClass("zoom-extra-large").addClass("zoom-#{accountZoomValue.name}")
		accountBgBodyValue = Steedos.getAccountBgBodyValue()
		if accountBgBodyValue.url
			$("body").css "backgroundImage","url(#{accountBgBodyValue.url})"
		else
			$("body").css "backgroundImage","url('/packages/steedos_theme/client/background/birds.jpg')"


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



Tracker.autorun (c) ->
	if Meteor.userId()
		if Steedos.subsBootstrap.ready() and Steedos.subsSpace.ready() and Steedos.subsWorkflow?.ready()
			$("body").removeClass("loading")
		else
			$("body").addClass("loading")
	else
		$("body").removeClass("loading")
