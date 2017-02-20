

	Meteor.publish 'flow_roles', (spaceId)->
		
		unless this.userId
			return this.ready()
		
		unless spaceId
			return this.ready()

		# console.log '[publish] flow_roles for space ' + spaceId

		return db.flow_roles.find({space: spaceId}, {fields: {name:1}});
