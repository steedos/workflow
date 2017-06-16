Tracker.autorun (c)->
	if Steedos.subsBootstrap.ready("my_spaces")
		spaceId = Steedos.getSpaceId()
		Steedos.setSpaceId(spaceId)



Steedos.subsSpace = new SubsManager();

Tracker.autorun (c)->
	spaceId = Session.get("spaceId")
	
	Steedos.subsSpace.clear();
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

Meteor.startup ->
	Tracker.autorun (c)->
		currentPath = FlowRouter.current().path
		if !Meteor.userId() and !/^\/steedos\b/.test(currentPath)
			# 没有登录且路由不以/steedos开头则跳转到登录界面
			FlowRouter.go "/steedos/sign-in";

Steedos.subsForwardRelated = new SubsManager()

Tracker.autorun (c)->
	space_id = Session.get('space_drop_down_selected_value')
	distribute_optional_flows = Session.get('distribute_optional_flows')
	Steedos.subsForwardRelated.reset();
	if space_id
		Steedos.subsForwardRelated.subscribe("my_space_user", space_id);
		Steedos.subsForwardRelated.subscribe("my_organizations", space_id);
		Steedos.subsForwardRelated.subscribe("categories", space_id);
		Steedos.subsForwardRelated.subscribe("forms", space_id);
		Steedos.subsForwardRelated.subscribe("flows", space_id);
	if distribute_optional_flows
		Steedos.subsForwardRelated.subscribe("distribute_optional_flows", distribute_optional_flows);


