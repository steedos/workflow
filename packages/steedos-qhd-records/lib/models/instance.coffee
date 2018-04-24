_eval = Npm.require('eval')

db.archive_classification = new Meteor.Collection('archive_classification')
db.archive_fonds = new Meteor.Collection('archive_fonds')
db.archive_retention = new Meteor.Collection('archive_retention')
db.archive_wenshu = new Meteor.Collection('archive_wenshu')
db.archive_audit = new Meteor.Collection('archive_audit')

@InstanceManager = {}

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
				console.log e
	return res