Template.instanceSignText.helpers InstanceSignText.helpers

Template.instanceSignText.events
	'click .instance-sign-text-btn': (event, template)->
#		$(".instance-view .btn-suggestion-toggle").click()
		Modal.show("instanceSignModal")