Steedos.subsInstance = new SubsManager
	cacheLimit: 100

Steedos.subsBootstrap.subscribe("user_inbox_instance");


db.form_versions = new Mongo.Collection("form_versions");
db.flow_versions = new Mongo.Collection("flow_versions");

db.my_approves = new Mongo.Collection("my_approves");

Steedos.subscribeFlowVersion = (space, flowId, flow_version)->
	Steedos.subsInstance.subscribe("flow_version", space, flowId , flow_version)

Steedos.subscribeFormVersion = (space, formId, form_version)->
	Steedos.subsInstance.subscribe("form_version", space, formId , form_version)

Steedos.subscribeInstance = (instance)->
#	console.log("instance.space: #{instance.space}, instance.flow: #{instance.flow}, instance.flow_version: #{instance.flow_version}")
	Steedos.subscribeFlowVersion(instance.space, instance.flow, instance.flow_version)
	Steedos.subscribeFormVersion(instance.space, instance.form, instance.form_version)
	Steedos.subsInstance.subscribe("instance_data", instance._id)


Tracker.autorun (c)->
#	console.log("subscribe instance...");
	instanceId = Session.get("instanceId")
	#	Steedos.instanceSpace.clear(); # 清理已订阅数据
	if instanceId
		Steedos.subsInstance.subscribe("cfs_instances", instanceId)

		instance = db.instances.findOne({_id: instanceId});
		if instance
			Steedos.subscribeInstance(instance);
		else
			Steedos.subsInstance.subscribe("instance_data", instanceId)

Tracker.autorun (c) ->
	if Steedos.subsInstance.ready()
		if Session.get("instanceId")
			instance = db.instances.findOne({_id: Session.get("instanceId")});
			if !instance
				console.error "instance not find ,id is instanceId"
				FlowRouter.go("/workflow/space/" + Session.get("spaceId") + "/" + Session.get("box") + "/")
				Session.set("instance_loading", false);
	
