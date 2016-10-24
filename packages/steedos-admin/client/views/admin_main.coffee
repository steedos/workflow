Template.admin_main.helpers 

	instanceId: ->
		return Session.get("instanceId")

	instance_loading: ->
		return Session.get("instance_loading")
		
	subsReady: ->
		return Steedos.subsBootstrap.ready() and Steedos.subsSpace.ready();

Template.admin_main.onCreated ->


Template.admin_main.onRendered ->
