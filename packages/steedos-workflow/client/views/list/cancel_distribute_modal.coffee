Template.cancel_distribute_modal.helpers
	traces: ()->
		instr = db.instance_traces.findOne(Session.get("instanceId"))
		if not instr
			return
		traces = []
		userId = Meteor.userId()
		_.each instr.traces, (t)->
			newt = {_id: t._id, name:t.name, distribute_approves: []}
			if t.approves
				_.each t.approves, (a)->
					if a.type is 'distribute' and a.from_user is userId
						newt.distribute_approves.push(a)

			if not _.isEmpty(newt.distribute_approves)
				traces.push(newt)

		return traces




Template.cancel_distribute_modal.events
	'click .for-input': (event, template) ->
		approveid = event.currentTarget.dataset.approveid
		if $("#"+approveid)
			$("#"+approveid).click()

	'click .cancel_distribute_modal_all_approve_toggle': (event, template) ->
		trace_id = event.currentTarget.id 
		$("[name='#{trace_id}']").prop('checked', event.currentTarget.checked)


Template.cancel_distribute_modal.onCreated ->

	$("body").addClass("loading")

	Steedos.subs["instance_traces"].subscribe("instance_traces", Session.get("instanceId"))

	Tracker.autorun () ->
		if Steedos.subs["instance_traces"].ready()
			$("body").removeClass("loading")