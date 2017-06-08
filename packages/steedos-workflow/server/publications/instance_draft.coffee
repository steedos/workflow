Meteor.publish 'instances_draft', (spaceId)->
	unless this.userId
		return this.ready()

	userId = this.userId
	return db.instances.find({state:"draft",space:spaceId,submitter:userId,inbox_users:{$exists:false}})