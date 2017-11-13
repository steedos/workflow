Meteor.publish 'instances_by_ids', (instance_ids)->
	check(instance_ids, Array)

	unless this.userId
		return this.ready()
	
	unless instance_ids
		return this.ready()

	if _.isEmpty(instance_ids)
		return this.ready()

	return db.instances.find({_id: {$in: instance_ids}}, {fields: {state: 1}})

