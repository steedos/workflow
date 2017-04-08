Template.related_instances.helpers
	showRelatedInstaces: ->
		ins = WorkflowManager.getInstance();
		if ins.related_instances && _.isArray(ins.related_instances)
			return true
		else
			return false

	related_instaces: ->
		ins = WorkflowManager.getInstance();
		if ins.related_instances && _.isArray(ins.related_instances)
			return db.instances.find({_id: {$in: ins.related_instances}}, {fields: {space: 1, name: 1}}).fetch()

	related_instace_url: (ins) ->
		return Meteor.absoluteUrl("workflow/space/"+ins.space+"/view/readonly/" + ins._id)