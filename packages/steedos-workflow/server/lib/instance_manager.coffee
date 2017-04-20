_eval = Npm.require('eval')

InstanceManager = {}

InstanceManager.handlerInstanceByFieldMap = (ins) ->
	console.log "run handlerInstanceByFieldMap"
	res = ins
	if ins
		flow = db.flows.findOne({_id: ins.flow});

		if flow?.field_map
			console.log "has flow.field_map"

			script = "var instances = #{flow.field_map}; exports.instances = instances";
			try
				res = _eval(script, "handlerInstanceByFieldMap", ins, false).instances
			catch e
#				res = {}
				console.log e

	console.log "handlerInstanceByFieldMap end"
	return res