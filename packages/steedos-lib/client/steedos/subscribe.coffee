Steedos.subsSpace = new SubsManager();

Tracker.autorun (c)->
	spaceId = Session.get("spaceId")
	
	Steedos.subsSpace.clear();
	if spaceId
		Steedos.subsSpace.subscribe("categories", spaceId)
		Steedos.subsSpace.subscribe("forms", spaceId)
		Steedos.subsSpace.subscribe("flows", spaceId)

		Steedos.subsSpace.subscribe("space_user_signs", spaceId);

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


Steedos.subsModules = new SubsManager();

Tracker.autorun (c)->
	user_id = Meteor.userId()
	Steedos.subsModules.reset();
	if user_id
		Steedos.subsModules.subscribe("modules");