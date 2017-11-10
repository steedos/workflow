Meteor.publish 'instance_data', (instanceId)->
	unless this.userId
		return this.ready()

	unless instanceId
		return this.ready()

	instance = db.instances.findOne({_id: instanceId})

	traces = new Array();

	console.time("instance_data")

	that = this

	instance?.traces?.forEach (trace)->

		_trace = _.clone(trace)

		approves = new Array()

		trace?.approves?.forEach (approve)->

			if approve.type != 'cc' || approve.user == that.userId || approve.handler == that.userId || !_.isEmpty(approve.opinion_fields_code)

				delete approve.handler_organization_fullname

				delete approve.handler_organization_name

				delete approve.handler_organization

				delete approve.cost_time

				delete approve.read_date

				delete approve.user_name

				delete approve.deadline

				delete approve.remind_date

				delete approve.reminded_count

				delete approve.modified_by

				delete approve.modified

				delete approve.geolocation

				delete approve.cc_users

				approves.push(approve)

		_trace.approves = approves

		traces.push(_trace)

	instance.traces = traces;

	console.timeEnd("instance_data")

	this.added("instances", instance._id, instance);

	this.ready();

#	return db.instances.find({_id: instanceId}, {
#		fields: {
#			"attachments": 0,
#			"record_synced": 0,
#			"distribute_from_instances": 0,
#
#			"traces.approves.handler_organization_fullname": 0,
#			"traces.approves.handler_organization_name": 0,
#			"traces.approves.handler_organization": 0,
#			"traces.approves.cost_time": 0,
#			"traces.approves.read_date": 0,
#			"traces.approves.is_error": 0,
#			"traces.approves.user_name": 0,
#			"traces.approves.deadline": 0,
#			"traces.approves.remind_date": 0,
#			"traces.approves.reminded_count": 0,
#			"traces.approves.modified_by": 0,
#			"traces.approves.modified": 0,
#			"traces.approves.geolocation": 0,
#			"traces.approves.cc_users": 0,
#			"traces.approves.values": 0,
#			"traces.approves.next_steps": 0,
#
#			"traces.approves.instance": 0,
#			"traces.approves.trace": 0,
#			"traces.approves.start_date": 0,
#			"traces.approves.is_read": 0,
#			"traces.approves.finish_date": 0,
#			"traces.approves.next_steps": 0,
#			"traces.approves.next_steps": 0,
#			"traces.approves.next_steps": 0,
#			"traces.approves.next_steps": 0,
#
#
#		}
#	})

#	return [instance]