Meteor.publishComposite "user_inbox_instance", ()->
	unless this.userId
		return this.ready()

	userSpaceIds = db.space_users.find({
		user: this.userId,
		user_accepted: true
	}, {fields: {space: 1}}).fetch().getEach("space");
	query = {space: {$in: userSpaceIds}}

	query.$or = [{inbox_users: this.userId}, {cc_users: this.userId}]

	find: ->
		db.instances.find(query, {
			fields: {
				space: 1,
				applicant_name: 1,
				flow: 1,
				inbox_users: 1,
				cc_users: 1,
				state: 1,
				name: 1,
				modified: 1,
				form: 1
			}, sort: {modified: -1}, skip: 0, limit: 200
		});
	children: [
		{
			find: (instance, post)->
				db.flows.find({_id: instance.flow}, {fields: {name: 1, space: 1}});
		}
	]

