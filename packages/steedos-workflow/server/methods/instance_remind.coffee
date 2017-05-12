Meteor.methods
	instance_remind: (remind_users, remind_count, remind_deadline, instance_id, trace_id)->
		check remind_users, Array
		check remind_count, Match.OneOf('single', 'multi')
		check remind_deadline, Date
		check instance_id, String
		check trace_id, String

		last_remind_users = new Array
		ins = db.instances.findOne({_id: instance_id}, {fields: {name: 1, traces: 1}})
		trace = _.find ins.traces, (t)->
			return t._id is trace_id

		if remind_count is 'single'
			_.each trace.approves, (ap)->
				if remind_users.includes(ap.user) and ap.is_finished isnt true
					last_remind_users.push ap.user
		else if remind_count is 'multi'
			_.each trace.approves, (ap)->
				if remind_users.includes(ap.user) and ap.is_finished isnt true
					last_remind_users.push ap.user
					ap.manual_deadline = remind_deadline
			if not _.isEmpty(last_remind_users)
				db.instances.update({_id: instance_id, 'traces._id': trace_id}, {$set: {'traces.$.approves': trace.approves}})

		uuflowManager.sendRemindSMS ins.name, remind_deadline, last_remind_users

		return true
