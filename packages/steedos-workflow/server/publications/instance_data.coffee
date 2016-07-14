
	Meteor.publish 'instance_data', (instanceId)->
		
		unless this.userId
			return this.ready()
		
		unless instanceId
			return this.ready()

		console.log '[publish] instance ' + instanceId

		instance = db.instances.findOne({_id: instanceId})

		return [
			db.instances.find({_id: instanceId}),
		]
