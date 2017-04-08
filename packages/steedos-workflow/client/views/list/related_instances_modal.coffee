Template.related_instances_modal.helpers
	instances_doc: ->
		return db.instances.findOne({_id: Session.get("instanceId")});

#	selectedOptions: ->
#		opts = AutoForm.getFieldValue("related_instances", "related_instances");
#		if opts
#			return opts
#		else
#			return ""