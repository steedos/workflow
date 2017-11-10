Meteor.publish 'instance_data', (instanceId, isAllData)->
	unless this.userId
		return this.ready()

	unless instanceId
		return this.ready()

	self = this;

	triggerChangeFields = ['state', 'name', 'final_decision', 'form_version', 'flow_version', 'cc_users', 'inbox_users',
		'outbox_users', '_traces_length']

	triggerChangeFieldsValues = {}


	getMiniTraces = (_traces)->
		traces = new Array();

		_traces?.forEach (trace)->
			_trace = _.clone(trace)

			approves = new Array()

			trace?.approves?.forEach (approve)->
				_approve = new Object();

				_approve._id = approve._id

				_approve.is_finished = approve.is_finished

				_approve.user = approve.user

				_approve.handler = approve.handler

				_approve.handler_name = approve.handler_name

				_approve.type = approve.type

				_approve.start_date = approve.start_date

				_approve.description = approve.description

				_approve.is_read = approve.is_read

				_approve.judge = approve.judge

				_approve.finish_date = approve.finish_date

				_approve.from_user_name = approve.from_user_name

				_approve.from_user = approve.from_user

				_approve.cc_description = approve.cc_description

				_approve.from_user = approve.from_user

				approves.push(_approve)

			_trace.approves = approves

			traces.push(_trace)

		return traces


	getMiniInstance = (_instanceId, isAllData)->
		instance = db.instances.findOne({_id: _instanceId})

		if instance

			if isAllData
				instance.allTraces = getMiniTraces(instance.traces)

			triggerChangeFields.forEach (key)->
				if key == '_traces_length'
					triggerChangeFieldsValues[key] = instance.traces?.length || 0
				else
					triggerChangeFieldsValues[key] = instance[key]

			hasOpinionField = InstanceSignText.includesOpinionField(instance.form, instance.form_version)

			if hasOpinionField && !isAllData

				traces = new Array();

				console.time("instance_data")

				instance?.traces?.forEach (trace)->
					_trace = _.clone(trace)

					approves = new Array()

					trace?.approves?.forEach (approve)->
						if approve.type != 'cc' || approve.user == self.userId || approve.handler == self.userId || !_.isEmpty(approve.opinion_fields_code)

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

							delete approve.from_approve_id

							approves.push(approve)

					_trace.approves = approves

					traces.push(_trace)

				instance.traces = traces;

				console.timeEnd("instance_data")

		return instance


	needChange = (changeFields)->
		if changeFields

			_change = false

			_rev = _.find triggerChangeFields, (key)->
				_key = key

				if key == '_traces_length'
					_key = 'traces'

				if _.has(changeFields, _key)

					if key == '_traces_length'
						return !_.isEqual(triggerChangeFieldsValues[key], changeFields.traces?.length || 0)
					else
						console.log(triggerChangeFieldsValues[key], changeFields[key])
						return !_.isEqual(triggerChangeFieldsValues[key], changeFields[key])

			if _rev

				console.log("needChange", _rev)

				_change = true

			return _change

		return true

	handle = db.instances.find({_id: instanceId}).observeChanges {
		changed: (id, fields)->
			console.log("fields", fields)
			if(needChange(fields))
				self.changed("instances", id, getMiniInstance(id, isAllData));
		removed: (id)->
			self.removed("instances", id);
	}

	instance = getMiniInstance(instanceId, isAllData)

	self.added("instances", instance._id, instance);

	self.ready();

	self.onStop ()->
		handle.stop()

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