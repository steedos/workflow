Meteor.publish 'flows', (spaceId)->
	unless this.userId
		return this.ready()

	unless spaceId
		return this.ready()

	# 第一次订阅时初始化工作区
	if db.flows.find({space: spaceId}).count() == 0
		db.spaces.createTemplateFormAndFlow(spaceId)

	console.log '[publish] flows for space ' + spaceId

	return db.flows.find({space: spaceId}, {
		fields: {
			name: 1,
			form: 1,
			state: 1,
			perms: 1,
			instance_style: 1,
			print_template: 1,
			instance_template: 1,
			events: 1
		}
	})


Meteor.publish 'flow', (spaceId, flowId, versionId) ->
	unless this.userId
		return this.ready()

	unless spaceId
		return this.ready()

	unless flowId
		return this.ready()

	unless versionId
		return this.ready()

	console.log "[publish] flow for space:#{spaceId}, flowId:#{spaceId}, versionId: #{versionId} "

	flow = db.flows.find({_id: flowId, "historys._id": versionId}, {fields: {"historys.$": 1, current: 1}})

	if flow.count() < 1
		flow = db.flows.find({_id: flowId}, {fields: {current: 1}})

	return flow