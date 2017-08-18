Template.iframeLayout.helpers 
	
	subsReady: ->
		return Steedos.subsBootstrap.ready()


Template.iframeLayout.events

Template.iframeLayout.onCreated ()->
	$("body").addClass("loading")

Template.iframeLayout.onRendered ()->
	$("#main_iframe").load ()->
		$("body").removeClass("loading")

