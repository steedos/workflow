
Meteor.publish "instance_tabular", (tableName, ids, fields)->
	console.log "instance_tabular user is #{this.userId}"

	console.log "tableName is #{tableName}"

	console.log "ids is #{ids}"

	console.log "fields is #{fields}"

	console.log fields

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

#	my_approves 对象的 _id 值为 instance._id
	handle = db.instances.find({_id: {$in: ids}}).observeChanges {
		changed: (id)->
			myApprove = getMyApprove(self.userId, id)
			if myApprove
				self.changed("my_approves", id, myApprove);
#			else
#				self.removed("my_approves", id)
#		removed: (id)->
#			self.removed("my_approves", id)
	}

	ids.forEach (id)->
		myApprove = getMyApprove(self.userId, id)
		if myApprove
			self.added("my_approves", id, myApprove);

	self.ready();
	self.onStop ()->
		handle.stop()

	return db.instances.find({_id: {$in: ids}}, {fields: fields})

Meteor.publish "instance_my_approves", (space)->
	console.log "instance_tabular user is #{this.userId}"

	unless this.userId
		return this.ready()

	self = this;

	getMyApprove = (userId, instance)->

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

	query = {space: space, $or: [{inbox_users: self.userId}, {cc_users: self.userId}]}

	handle = db.instances.find(query).observeChanges {
		changed: (id)->
			instance = db.instances.findOne({_id: id})
			if instance
				myApprove = getMyApprove(self.userId, instance)
				if myApprove
					self.changed("my_approves", id, myApprove);
				else
					self.removed("my_approves", id)
		removed: (id)->
			self.removed("my_approves", id)
	}

	db.instances.find(query).forEach (instance)->
		myApprove = getMyApprove(self.userId, instance)
		if myApprove
			self.added("my_approves", instance._id, myApprove);

	self.ready();
	self.onStop ()->
		handle.stop()