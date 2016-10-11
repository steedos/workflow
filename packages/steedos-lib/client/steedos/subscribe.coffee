Steedos.subsBootstrap = new SubsManager();
Steedos.subsBootstrap.subscribe('userData')
Steedos.subsBootstrap.subscribe('apps')
Steedos.subsBootstrap.subscribe('my_spaces')

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
	instanceId = Session.get('instanceId')
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

	if instanceId
		Steedos.subsSpace.subscribe("cfs_instances", instanceId)

	Steedos.subsSpace.subscribe("steedos_keyvalues")


Tracker.autorun (c)->
	if Steedos.subsSpace.ready("apps")
		if Session.get 'isRootLoading'
			Session.set("isRootLoading",false)
			$("body").removeClass("loading")
			firstApp = Steedos.getSpaceApps().fetch()[0]
			if firstApp
				FlowRouter.go("/app/" + firstApp._id)
			else
				FlowRouter.go("/steedos/springboard")
