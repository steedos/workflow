Steedos.instanceSpace = new SubsManager();

Steedos.flowVersionSpace = new SubsManager();

Steedos.formVersionSpace = new SubsManager();

#Steedos.instanceMyApproveSpace = new SubsManager();

db.form_versions = new Mongo.Collection("form_versions");
db.flow_versions = new Mongo.Collection("flow_versions");

db.my_approves = new Mongo.Collection("my_approves");

Steedos.subscribeFlowVersion = (space, flowId, flow_version)->
#	flow 存在，并且存在current和historys属性，但是未能根据flow_version 找到记录时，清理缓存数据
	flow = db.flows.findOne({_id: flowId})
	if flow
		if flow.current && flow.historys && !db.flows.findOne({_id: flowId, $or:[{"current._id":flow_version},{"historys._id" : flow_version}]})
			Steedos.flowSpace.clear();
	Steedos.flowVersionSpace.subscribe("flow_version", space, flowId , flow_version)

Steedos.subscribeFormVersion = (space, formId, form_version)->
	Steedos.formVersionSpace.subscribe("form_version", space, formId , form_version)

Steedos.subscribeInstance = (instance)->
#	console.log("instance.space: #{instance.space}, instance.flow: #{instance.flow}, instance.flow_version: #{instance.flow_version}")
	Steedos.subscribeFlowVersion(instance.space, instance.flow, instance.flow_version)
	Steedos.subscribeFormVersion(instance.space, instance.form, instance.form_version)
	Steedos.instanceSpace.subscribe("instance_data", instance._id)


Tracker.autorun (c)->
#	console.log("subscribe instance...");
	instanceId = Session.get("instanceId")
	#	Steedos.instanceSpace.clear(); # 清理已订阅数据
	if instanceId
		instance = db.instances.findOne({_id: instanceId});

		if instance
			Steedos.subscribeInstance(instance);
		else
			Steedos.instanceSpace.subscribe("instance_data", instanceId)

Tracker.autorun (c) ->
	if Steedos.instanceSpace.ready()
		if Session.get("instanceId")
			instance = db.instances.findOne({_id: Session.get("instanceId")});
			if !instance
				console.error "instance not find ,id is instanceId"
				FlowRouter.go("/workflow/space/" + Session.get("spaceId") + "/" + Session.get("box") + "/")
				Session.set("instance_loading", false);

#Tracker.autorun (c) ->
#	if Session.get("spaceId")
#		Steedos.instanceMyApproveSpace.subscribe("instance_my_approves", Session.get("spaceId"))