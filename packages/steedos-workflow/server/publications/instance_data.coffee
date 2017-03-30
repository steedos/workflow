Meteor.publish 'instance_data', (instanceId)->
		
	unless this.userId
		return this.ready()
	
	unless instanceId
		return this.ready()


	return db.instances.find({_id: instanceId})
