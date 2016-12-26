
Template.workflowLayout.onRendered ->
	$('body').removeClass('fixed');


Template.workflowLayout.helpers 
	subsReady: ->
		return Steedos.subsBootstrap.ready()

Template.workflowLayout.events
	"click #navigation-back": (e, t) ->
		NavigationController.back(); 
