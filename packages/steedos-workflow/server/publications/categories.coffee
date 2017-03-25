Meteor.publish 'categories', (spaceId)->

	unless this.userId
		return this.ready()
	
	unless spaceId
		return this.ready()


	return db.categories.find({space: spaceId}, {fields: {name: 1, space: 1}})