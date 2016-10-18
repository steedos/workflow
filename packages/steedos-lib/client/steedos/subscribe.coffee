Steedos.subsBootstrap = new SubsManager();
Steedos.subsBootstrap.subscribe('userData')
Steedos.subsBootstrap.subscribe('apps')
Steedos.subsBootstrap.subscribe('my_spaces')
Steedos.subsBootstrap.subscribe("steedos_keyvalues")

Tracker.autorun (c)->
	if Steedos.subsBootstrap.ready("my_spaces")
		spaceId = Steedos.getSpaceId()
		if spaceId
			space = db.spaces.findOne(spaceId)
			if space
				Steedos.setSpaceId(space._id)
			else
				space = db.spaces.findOne()
				if space
					Steedos.setSpaceId(space._id)
		# 默认选中第一个space
		else
			space = db.spaces.findOne()
			if space
				Steedos.setSpaceId(space._id)



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

Steedos.subsInstance = new SubsManager();

Tracker.autorun (c)->
	instanceId = Session.get('instanceId')
	Steedos.subsInstance.reset()
	if instanceId
		Steedos.subsInstance.subscribe("cfs_instances", instanceId)

Tracker.autorun (c)->
	if Steedos.subsSpace.ready("apps")
		if FlowRouter.current().path == "/"
			$("body").removeClass("loading")
			firstApp = Steedos.getSpaceFirstApp()
			if firstApp
				FlowRouter.go("/app/" + firstApp._id)
			else
				FlowRouter.go("/steedos/springboard")

Tracker.autorun (c)->
	if Steedos.subsBootstrap.ready("steedos_keyvalues")
		accountBgBodyValue = Steedos.getAccountBgBodyValue()
		if accountBgBodyValue.url
			$("body").css "backgroundImage","url(#{accountBgBodyValue.url})"
		else
			$("body").removeAttr "style"


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
