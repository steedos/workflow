Template.instanceSignText.helpers InstanceSignText.helpers

Template.instanceSignText.events
	'click .instance-sign-text-btn': (event, template)->
#		$(".instance-view .btn-suggestion-toggle").click()
		Modal.show("instanceSignModal")

	'click .instance-sign-opinion-btn': (event, template)->

		val = Session.get("instance_my_approve_description") + event.target.text + t("instance_sign_period")

		$("#suggestion").val(val).trigger("input").focus();

#		Session.set "instance_my_approve_description", val