_eval = Npm.require('eval')

InstanceManager = {}

logger = new Logger 'Workflow -> InstanceManager'

InstanceManager.handlerInstanceByFieldMap = (ins) ->
	res = ins
	if ins
		flow = db.flows.findOne({_id: ins.flow});

		if flow?.field_map

			context = _.clone(ins)

			context._ = _

			script = "var instances = #{flow.field_map}; exports.instances = instances";
			try
				res = _eval(script, "handlerInstanceByFieldMap", context, false).instances
			catch e
				res = {_error: e}
				logger.error e
	return res