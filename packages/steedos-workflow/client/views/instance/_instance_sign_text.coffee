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
		return Template.instance().data.default || TAPi18n.__("instance_default_opinion")

	traces: ()->
		InstanceformTemplate.helpers.traces()

	trace: (stepName, only_cc_opinion, image_sign)->
		instance = InstanceformTemplate.helpers.instance()

		is_completed = instance?.state == "completed"

		completed_date = if is_completed then _.last(instance.traces)?.finish_date?.getTime() else 0

		traces = InstanceformTemplate.helpers.traces()

		approves = _.clone(traces[stepName])

		approves = _.filter approves, (a)->
			return a.type isnt "forward" and a.type isnt "distribute"

		if only_cc_opinion
			approves = approves?.filterProperty("type", "cc")

		approvesGroup = _.groupBy(approves, "handler");

		hasNext = (approve, approvesGroup) ->
			handlerApproves = approvesGroup[approve.handler]
			return _.indexOf(handlerApproves, approve) + 1 < handlerApproves.length

		haveDescriptionApprove = (approve, approvesGroup) ->
			handlerApproves = approvesGroup[approve.handler]

			descriptionApproves = _.filter handlerApproves, (a)->
				if a.description
					return true
				return false

			if descriptionApproves.length == 0
				return false

			return true


		approves.forEach (approve) ->
#			有输入意见 或 最新一条并且用户没有输入过意见
#			if !approve.is_finished || approve.description || (!hasNext(approve, approvesGroup) && !haveDescriptionApprove(approve, approvesGroup))
			if !hasNext(approve, approvesGroup)
				approve._display = true


		approves = _.filter approves, (a) ->
			if is_completed
				return a._display == true && a.is_finished && a.finish_date?.getTime() <= completed_date
			else
				return a._display == true

		return approves

	include: (a, b) ->
		return InstanceformTemplate.helpers.include(a, b)

	unempty: (val)->
		return InstanceformTemplate.helpers.unempty(val)

	formatDate: (date, options)->
		if !options
			options = {"format": "YYYY-MM-DD"}

		return InstanceformTemplate.helpers.formatDate(date, options)

	isMyApprove: (only_cc_opinion) ->
		if Meteor.isClient
			ins = WorkflowManager.getInstance();
			if InstanceManager.isCC(ins) && Template.instance().data.name
				if Template.instance().data.name == InstanceManager.getCurrentApprove()?.opinion_field_code
					return true
				else
					return false

			if !InstanceManager.isCC(ins) && only_cc_opinion
				return false

			if InstanceManager.getCurrentApprove()
				return true
		return false

	myApproveDescription: (approveId)->
		if Meteor.isClient
			return TracesTemplate.helpers.myApproveDescription(approveId)

	now: ()->
		return new Date();

	isReadOnly: ()->
		if Meteor.isClient
			return ApproveManager.isReadOnly()
		return false

	isOpinionOfField: (approve)->
		if approve.type == "cc" && Template.instance().data.name
			if Template.instance().data.name == approve.opinion_field_code
				return true
			else
				return false
		else
			return true;

	markDownToHtml: (markDownString)->
		if markDownString
			renderer = new Markdown.Renderer();
			renderer.link = (href, title, text) ->
				return "<a target='_blank' href='#{href}' title='#{title}'>#{text}</a>"
			return Spacebars.SafeString(Markdown(markDownString, {renderer: renderer}))

	steps: (field_formula, step, only_cc_opinion, image_sign)->
		steps = []
		if !step

			if !field_formula
				field_formula = WorkflowManager.getInstanceFormVersion()?.fields?.findPropertyByPK("code", this.name).formula

			steps = InstanceformTemplate.helpers.getOpinionFieldStepsName(field_formula)
		else
			steps = [{stepName: step, only_cc_opinion: only_cc_opinion, image_sign: image_sign}]
		return steps

	imageSignData: (handler) ->
		return {user: handler}

	showSignImage: (handler, image_sign) ->
		spaceUserSign = ImageSign.helpers.spaceUserSign(handler);

		if spaceUserSign?.sign && image_sign
			return true
		else
			return false

	lastMyApproveDescription: ()->
		traces = InstanceformTemplate.helpers.traces()
		currentStep = InstanceManager.getCurrentStep();
		approves = _.clone(traces[currentStep.name])

		approves = approves.filterProperty("handler", Meteor.userId())

		if approves.length > 1
			return approves[approves.length - 2]?.description

		return "";

if Meteor.isServer
	InstanceSignText.helpers.defaultDescription = ->
		locale = Template.instance().view.template.steedosData.locale
		return Template.instance().data.default || TAPi18n.__("instance_default_opinion", {}, locale)