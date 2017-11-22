_eval = Npm.require('eval')

InstanceManager = {}

logger = new Logger 'Workflow -> InstanceManager'

InstanceManager.handlerInstanceByFieldMap = (ins, field_map) ->
	res = ins
	if ins
		if !field_map

			flow = db.flows.findOne({_id: ins.flow});

			if flow?.field_map
				field_map = flow.field_map

		if field_map
			context = _.clone(ins)

			context._ = _

			script = "var instances = #{field_map}; exports.instances = instances";
			try
				res = _eval(script, "handlerInstanceByFieldMap", context, false).instances
			catch e
				res = {_error: e}
				logger.error e
	return res

InstanceManager.getCurrentApprove = (instance, handler)->

	if !instance or !instance.traces or instance.traces.length < 1
		return

	currentTraces = instance.traces.filterProperty('is_finished', false)

	if currentTraces.length
		currentApproves = currentTraces[0].approves.filterProperty('is_finished', false).filterProperty('handler', handler)
		currentApprove = if currentApproves.length > 0 then currentApproves[0] else null

	#传阅的approve返回最新一条
	if !currentApprove or currentApprove.type == 'cc'
		# 当前是传阅
		_.each instance.traces, (t) ->
			_.each t.approves, (a) ->
				if a.type == 'cc' and a.user == handler and a.is_finished == false
					currentApprove = a
				return
			return

	if !currentApprove
		return

	return currentApprove

InstanceManager.getCurrentTrace = (instance, traceId)->
	return instance.traces.findPropertyByPK("_id", traceId)