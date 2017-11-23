Meteor.methods
	'get_batch_instances': (space, categoryId, flowIds)->
		if !this.userId
			return

		if !space
			return

		_batch_instances = InstanceManager.getBatchInstances(space, categoryId, flowIds, this.userId)

		return _batch_instances

	'get_batch_instances_count': (space, categoryId, flowIds)->
		if !this.userId
			return

		if !space
			return

		_batch_instances = InstanceManager.getBatchInstances(space, categoryId, flowIds, this.userId)

		return _batch_instances?.length || 0

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











