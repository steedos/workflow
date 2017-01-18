
Meteor.publish "instance_tabular", (tableName, ids, fields)->
#	console.log "instance_tabular user is #{this.userId}"

	unless this.userId
		return this.ready()

	check(tableName, String);

	check(ids, Array);

	check(fields, Match.Optional(Object))

	self = this;

	getMyApprove = (userId, instanceId)->
		instance = db.instances.findOne({_id: instanceId})
		if !instance
			return

		if !instance.traces || instance.traces.length < 1
			return

		notFinishedTraces = instance.traces.filterProperty("is_finished", false)

		if notFinishedTraces.length < 1
			return

		approves = notFinishedTraces[0].approves.filterProperty("is_finished", false).filterProperty("handler", userId);

		if approves.length > 0
			myApprove = approves[0]
			return {id: myApprove._id, instance: myApprove.instance, trace: myApprove.trace, is_read: myApprove.is_read, step: notFinishedTraces[0].step}
		return null

	handle = db.instances.find({_id: {$in: ids}}).observeChanges {
		changed: (id)->
			instance = db.instances.findOne({_id: id}, {fields: fields})
			myApprove = getMyApprove(self.userId, id)
			if myApprove
				instance.is_read = myApprove.is_read
			else
				instance.is_read = true

			self.changed("instances", id, instance);
		removed: (id)->
			self.removed("instances", id);
	}

	ids.forEach (id)->
		instance = db.instances.findOne({_id: id}, {fields: fields})
		myApprove = getMyApprove(self.userId, id)
		if myApprove
			instance.is_read = myApprove.is_read
		else
			instance.is_read = true
		self.added("instances", id, instance);

	self.ready();
	self.onStop ()->
		handle.stop()