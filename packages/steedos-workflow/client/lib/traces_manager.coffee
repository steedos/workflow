###
	获取传入步骤最近一次实际处理人
###
TracesManager.getStepLastHandlers = (stepId, instance) ->

	handlers = []

	traces = _.clone(instance.traces)

	stepTraces = _.filter traces, (trace)->
		return trace.step == stepId

	stepTraces.reverse()

	_.some stepTraces, (trace)->
		if trace.is_finished
			approves = trace?.approves || []

			approves.reverse()

			approves.forEach (approve)->
				if approve?.is_finished && approve?.type != 'cc'
					if ["approved", "rejected", "submitted", "readed"].includes(approve.judge)
						handlers.push approve.handler

			if handlers.length > 0
				return true


	return handlers;