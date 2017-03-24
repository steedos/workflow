Steedos.subs["InstanceInbox"] = new SubsManager
Steedos.subs["InstanceInbox"].subscribe("user_inbox_instance");


Steedos.subs["Instance"] = new SubsManager
	cacheLimit: 20

db.form_versions = new Mongo.Collection("form_versions");
db.flow_versions = new Mongo.Collection("flow_versions");

db.my_approves = new Mongo.Collection("my_approves");

Steedos.subscribeFlowVersion = (space, flowId, flow_version)->
	Steedos.subs["Instance"].subscribe("flow_version", space, flowId , flow_version)

Steedos.subscribeFormVersion = (space, formId, form_version)->
	Steedos.subs["Instance"].subscribe("form_version", space, formId , form_version)

Steedos.subscribeInstance = (instance)->
	Steedos.subscribeFlowVersion(instance.space, instance.flow, instance.flow_version)
	Steedos.subscribeFormVersion(instance.space, instance.form, instance.form_version)
	Steedos.subs["Instance"].subscribe("instance_data", instance._id)


Tracker.autorun (c)->
	instanceId = Session.get("instanceId")
	#	Steedos.instanceSpace.clear(); # 清理已订阅数据
	if instanceId
		Steedos.subs["Instance"].subscribe("cfs_instances", instanceId)

		instance = db.instances.findOne({_id: instanceId});
		if instance
			Steedos.subscribeInstance(instance);
		else
			Steedos.subs["Instance"].subscribe("instance_data", instanceId)

Tracker.autorun (c) ->
	if Steedos.subs["Instance"].ready()
		if Session.get("instanceId")
			instance = db.instances.findOne({_id: Session.get("instanceId")});
			if !instance
				console.error "instance not find ,id is instanceId"
				FlowRouter.go("/workflow/space/" + Session.get("spaceId") + "/" + Session.get("box") + "/")
				Session.set("instance_loading", false);
	
