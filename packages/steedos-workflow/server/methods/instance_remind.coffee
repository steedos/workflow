Meteor.methods
	instance_remind: (remind_users, remind_count, remind_deadline, instance_id, action_types, trace_id)->
		check remind_users, Array
		check remind_count, Match.OneOf('single', 'multi')
		check remind_deadline, Date
		check instance_id, String
		check action_types, Array
		check trace_id, String

		current_user_id = this.userId
		last_remind_users = new Array
		ins = db.instances.findOne({_id: instance_id}, {fields: {name: 1, traces: 1}})
		if action_types.includes('admin')
			if remind_count is 'single'
				_.each ins.traces, (t)->
					_.each t.approves, (ap)->
						if remind_users.includes(ap.user) and ap.is_finished isnt true
							last_remind_users.push ap.user
			else if remind_count is 'multi'
				_.each ins.traces, (t)->
					_.each t.approves, (ap)->
						if remind_users.includes(ap.user) and ap.is_finished isnt true
							last_remind_users.push ap.user
							ap.manual_deadline = remind_deadline
				if not _.isEmpty(last_remind_users)
					db.instances.update({_id: instance_id}, {$set: {'traces': ins.traces}})

		else if action_types.includes('applicant')
			trace = _.find ins.traces, (t)->
				return t._id is trace_id
			_.each trace.approves, (ap)->
				if remind_users.includes(ap.user) and ap.is_finished isnt true
					last_remind_users.push ap.user

		else if action_types.includes('cc')
			_.each ins.traces, (t)->
				_.each t.approves, (ap)->
					if remind_users.includes(ap.user) and ap.is_finished isnt true and ap.type is 'cc' and ap.from_user is current_user_id
						last_remind_users.push ap.user

		uuflowManager.sendRemindSMS ins.name, remind_deadline, last_remind_users

		return true
