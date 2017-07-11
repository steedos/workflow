Meteor.methods
	remove_related: (ins_id, re_ins_id)->
		ins = db.instances.findOne({_id: ins_id}, {fields: {related_instances: 1}})

		if ins
			res = ins.related_instances || []

			index = res.indexOf(re_ins_id)

			if index > -1
				res.remove(index)

			db.instances.update({_id: ins_id}, {$set: {related_instances: res}})