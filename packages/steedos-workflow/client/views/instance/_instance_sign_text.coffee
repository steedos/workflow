InstanceSignText.helpers =
	show: (stepName)->
		if Meteor.isClient
			if Session.get('instancePrint')
				return false
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

		if !options
			options = {"format":"YYYY-MM-DD"}

		return InstanceformTemplate.helpers.formatDate(date, options)

	isMyApprove: (approveId) ->
		if Meteor.isClient
			if InstanceManager.getCurrentApprove()
				return true
		return false

	myApproveDescription: (approveId)->
		if Meteor.isClient
			return TracesTemplate.helpers.myApproveDescription(approveId)

	now: ()->
		return new Date();