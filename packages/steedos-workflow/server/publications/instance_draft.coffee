Meteor.publish 'instances_draft', (spaceId)->
	unless this.userId
		return this.ready()

	userId = this.userId
	return db.instances.find({state:"draft",space:spaceId,submitter:userId,$or:[{inbox_users: {$exists:false}}, {inbox_users: []}]}, {fields: {_id: 1, state: 1, space: 1, submitter: 1, inbox_users: 1}})