Steedos.instanceSpace = new SubsManager();

Steedos.flowSpace = new SubsManager();

Steedos.formSpace = new SubsManager();

Tracker.autorun (c)->
	instanceId = Session.get("instanceId")
	#	Steedos.instanceSpace.clear(); # 清理已订阅数据

	instance = db.instances.findOne({_id: instanceId});

	if instance

		Steedos.instanceSpace.reset();

		Steedos.flowSpace.subscribe("flow", instance.space, instance.flow, instance.flow_version)
		Steedos.formSpace.subscribe("form", instance.space, instance.form, instance.form_version)
		Steedos.instanceSpace.subscribe("instance_data", instanceId)

Tracker.autorun (c)->
	if Steedos.instanceSpace.ready() && Steedos.flowSpace.ready() && Steedos.formSpace.ready()
		Session.set("instance_loading", false);