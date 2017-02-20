

Meteor.publish 'flow_positions', (spaceId)->
	
	unless this.userId
		return this.ready()
	
	unless spaceId
		return this.ready()

	# console.log '[publish] flow_positions for space ' + spaceId

	return db.flow_positions.find({space: spaceId}, {fields: {role:1, users: 1, org: 1}});
