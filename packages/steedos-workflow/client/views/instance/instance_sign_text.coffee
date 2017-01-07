Template.instanceSignText.helpers
	show: (stepName)->
		if InstanceManager.isInbox()
			currentStep = InstanceManager.getCurrentStep();
			return currentStep?.name == stepName
		return false

	defaultDescription: ()->
		return Template.instance().data.default

	traces: ()->
		InstanceformTemplate.helpers.traces()

	trace: (stepName)->
		traces = InstanceformTemplate.helpers.traces()
		return traces[stepName]

	include: (a, b) ->
		return InstanceformTemplate.helpers.include(a, b)

	unempty: (val)->
		return InstanceformTemplate.helpers.unempty(val)

	formatDate: (date, options)->
		return InstanceformTemplate.helpers.formatDate(date, options)

	isMyApprove: (approveId) ->
		if InstanceManager.getCurrentApprove()
			return true
		return false

	myApproveDescription: (approveId)->
		return TracesTemplate.helpers.myApproveDescription(approveId)

Template.instanceSignText.events
	'click .instance-sign-text-btn': (event, template)->
		console.log("click .instance-sign-text-btn");