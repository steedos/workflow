Template.related_instances.helpers RelatedInstances.helpers


Template.related_instances.events
	'click .ins-related-delete': (event, template)->
		Meteor.call("remove_related", Session?.get("instanceId"), this._id)