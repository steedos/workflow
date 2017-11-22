Meteor.methods
	'get_batch_instances': (space, categoryId, flowIds)->
		if !this.userId
			return

		if !space
			return

		_batch_instances = new Array()

		query = {space: space, inbox_users: this.userId}

		FIELDS = {name: 1, applicant_name: 1, submit_date: 1, flow_version: 1, "traces.step": 1, flow: 1}

		if categoryId

			if categoryId == '-1'
				unCategoryFlows = flowManager.getUnCategoriesFlows(space, {_id: 1}).fetch().getProperty("_id")
				query.flow = {$in: unCategoryFlows}
			else
				categoryFlows = flowManager.getCategoriesFlows(space, categoryId, {_id: 1}).fetch().getProperty("_id")
				query.flow = {$in: categoryFlows}

		if flowIds
			query.flow = {$in: flowIds}

		console.log("query", query)

		inbox_instances = db.instances.find(query, {fields: FIELDS, skip: 0, limit: 20000})

		inbox_instances.forEach (ins)->
			currentStepId = _.last(ins.traces).step #TODO 此代码不适用传阅批处理

			flow = db.flows.findOne({_id: ins.flow})

			currentStep = stepManager.getStep(ins, flow, currentStepId)

			if stepManager.allowBatch(currentStep)

				delete ins.flow_version

				delete ins.traces

				delete ins.flow

				_batch_instances.push(ins)

		return _batch_instances

	'get_my_approves': (instanceIds)->

		that = this

		if !that.userId
			return

		myApproves = new Array()

		instanceIds.forEach (insId)->
			instance = db.instances.findOne({_id: insId})

			flow = uuflowManager.getFlow(instance.flow)

			my_approves = InstanceManager.getCurrentApprove(instance, that.userId)

			if my_approves

				trace = InstanceManager.getCurrentTrace(instance, my_approves.trace)

				step = uuflowManager.getStep(instance, flow, trace.step)

				nextSteps = uuflowManager.getNextSteps(instance, flow, step, "")

				console.log("nextSteps length", instance._id, nextSteps.length)

				if nextSteps.length == 1
					next_user_ids = getHandlersManager.getHandlers(instance._id , nextSteps[0])
					console.log("next_user_ids length", instance._id, next_user_ids.length)
					if next_user_ids.length == 1

						my_approves.next_steps = [{step: nextSteps[0], users: next_user_ids}]

						myApproves.push(my_approves)

		return myApproves











