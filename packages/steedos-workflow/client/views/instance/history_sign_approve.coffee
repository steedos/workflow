Template.history_sign_approve.helpers
	sign_approves: ()->
		ins = WorkflowManager.getInstance()

		sign_approves = TracesManager.getHandlerSignShowApproves(ins, Meteor.userId()) || []
		# sign_approves = TracesManager.getHandlerSignShowApproves(ins, Meteor.userId(), true) || []
		# if InstanceManager.getCurrentApprove().description
		# 	sign_approves.push(InstanceManager.getCurrentApprove())
		return sign_approves.reverse()

	format: (time) ->
		return moment(time).format("YYYY-MM-DD HH:mm")


Template.history_sign_approve.events
	'hide.bs.modal #history-sign-approve': (event, template) ->
		Modal.allowMultiple = false;
		return true;

	'click .history-sign-approve .use-suggestion': (event, template) ->
		template.data.parent.history_approve.set(this)
		Modal.hide(template)

	'click .select-suggestion input': (event, template) ->
		targetObj = {}

		sign_show = $(event.target).is(":checked")

		ins = WorkflowManager.getInstance()
		sign_approves = TracesManager.getHandlerSignShowApproves(ins, Meteor.userId()) || []

		currentApproveId = event.target.value

		sign_approves.forEach (approve)->
			if approve._id == currentApproveId
				targetObj = approve

		Meteor.call('update_sign_show', targetObj.instance, targetObj.trace, targetObj._id, sign_show)


		event.stopPropagation()
		