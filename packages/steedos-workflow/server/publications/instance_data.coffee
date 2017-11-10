Meteor.publish 'instance_data', (instanceId, isAllData)->
	unless this.userId
		return this.ready()

	unless instanceId
		return this.ready()

	self = this;

	miniApproveFields = ['_id', 'is_finished', 'user', 'handler', 'handler_name', 'type', 'start_date', 'description',
		'is_read', 'judge', 'finish_date', 'from_user_name', 'from_user', 'cc_description']

	triggerChangeFields = ['form_version', 'flow_version', '_my_approve_ids']

	triggerChangeFieldsValues = {}

	instance_fields_0 = {
		"record_synced": 0,
		"distribute_from_instances": 0,

		"traces.approves.handler_organization_fullname": 0,
		"traces.approves.handler_organization_name": 0,
		"traces.approves.handler_organization": 0,
		"traces.approves.cost_time": 0,
		"traces.approves.read_date": 0,
		"traces.approves.is_error": 0,
		"traces.approves.user_name": 0,
		"traces.approves.deadline": 0,
		"traces.approves.remind_date": 0,
		"traces.approves.reminded_count": 0,
		"traces.approves.modified_by": 0,
		"traces.approves.modified": 0,
		"traces.approves.geolocation": 0,
		"traces.approves.cc_users": 0,
		"traces.approves.from_approve_id": 0
	}


	getMiniTraces = (_traces)->
		traces = new Array();

		_traces?.forEach (trace)->
			_trace = _.clone(trace)

			approves = new Array()

			trace?.approves?.forEach (approve)->
				_approve = new Object();

				miniApproveFields.forEach (f)->
					_approve[f] = approve[f]

				approves.push(_approve)

			_trace.approves = approves

			traces.push(_trace)

		return traces

	getMyapproveIds = (traces)->
		myApproveIds = new Array()

		traces?.forEach (trace)->
			trace?.approves?.forEach (approve)->
				if (approve.user == self.userId || approve.handler == self.userId) && approve.is_finished
					myApproveIds.push(approve._id)

		return myApproveIds


	getMiniInstance = (_instanceId, isAllData)->
		instance = db.instances.findOne({_id: _instanceId}, {fields: instance_fields_0})

		if instance

			if isAllData
				instance.allTraces = getMiniTraces(instance.traces)

			triggerChangeFields.forEach (key)->
				if key == '_my_approve_ids'
					triggerChangeFieldsValues[key] = getMyapproveIds(instance.traces)
				else
					triggerChangeFieldsValues[key] = instance[key]

			hasOpinionField = InstanceSignText.includesOpinionField(instance.form, instance.form_version)

			if hasOpinionField && !isAllData

				traces = new Array();

				instance?.traces?.forEach (trace)->
					_trace = _.clone(trace)

					approves = new Array()

					trace?.approves?.forEach (approve)->
						if approve.type != 'cc' || approve.user == self.userId || approve.handler == self.userId || !_.isEmpty(approve.opinion_fields_code)
							approves.push(approve)

					_trace.approves = approves

					traces.push(_trace)

				instance.traces = traces;

		return instance


	needChange = (changeFields)->
		if changeFields

			_change = false

			_rev = _.find triggerChangeFields, (key)->
				_key = key

				if key == '_my_approve_ids'
					_key = 'traces'

				if _.has(changeFields, _key)

					if key == '_my_approve_ids'

						_my_approve_ids = getMyapproveIds(changeFields.traces)

						return !_.isEqual(triggerChangeFieldsValues[key], _my_approve_ids)
					else
						console.log(triggerChangeFieldsValues[key], changeFields[key])
						return !_.isEqual(triggerChangeFieldsValues[key], changeFields[key])

			if _rev
				_change = true

			return _change

		return true

	handle = db.instances.find({_id: instanceId}).observeChanges {
		changed: (id, fields)->
			if( true || needChange(fields))
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