Steedos.instanceSpace = new SubsManager();

Steedos.flowSpace = new SubsManager();

Steedos.formSpace = new SubsManager();

Steedos.subscribeInstance = (instance)->
	Steedos.flowSpace.subscribe("flow", instance.space, instance.flow, instance.flow_version)
	Steedos.formSpace.subscribe("form", instance.space, instance.form, instance.form_version)
	Steedos.instanceSpace.subscribe("instance_data", instance._id)


Tracker.autorun (c)->
	instanceId = Session.get("instanceId")
	#	Steedos.instanceSpace.clear(); # 清理已订阅数据

	instance = db.instances.findOne({_id: instanceId});

	if instance
		Steedos.subscribeInstance(instance);