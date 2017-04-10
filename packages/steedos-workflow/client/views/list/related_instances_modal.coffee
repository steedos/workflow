Template.related_instances_modal.helpers
	instances_doc: ->
		return db.instances.findOne({_id: Session.get("instanceId")});

#	selectedOptions: ->
#		opts = AutoForm.getFieldValue("related_instances", "related_instances");
#		if opts
#			return opts
#		else
#			return ""
	schema: ->
		return db.instances._simpleSchema;

Template.related_instances_modal.events
	'click .btn-submit-related-instances': ()->
		$("#related_instances").submit();
		$(".btn-data-dismiss").click();