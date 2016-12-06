Template.instance_view.helpers
	instance: ->
		Session.get("change_date")
		if (Session.get("instanceId"))
			steedos_instance = WorkflowManager.getInstance();
			return steedos_instance;


	unequals: (a, b) ->
		return !(a == b)

# 只有在流程属性上设置tableStype 为true 并且不是手机版才返回true.
	isTableView: (flowId)->
		flow = WorkflowManager.getFlow(flowId);

		if Steedos.isMobile()
			return false

		if flow?.instance_style == 'table'
			return true
		# return true
		return false;

	readOnlyView: ()->
		steedos_instance = WorkflowManager.getInstance();
		return InstanceReadOnlyTemplate.getInstanceView(db.users.findOne({_id: Meteor.userId()}), Session.get("spaceId"), steedos_instance);
	isIReadable: ()->
		console.log(ApproveManager.isReadOnly());
		return ApproveManager.isReadOnly();


Template.instance_view.onRendered ->
	$(".workflow-main").addClass("instance-show")
	$('[data-toggle="tooltip"]').tooltip()
	if !Steedos.isMobile()
		$(".instance").perfectScrollbar();

Template.instance_view.events
	'change .instance .form-control,.instance .suggestion-control,.instance .checkbox input,.instance .af-radio-group input,.instance .af-checkbox-group input': (event, template) ->
		Session.set("instance_change", true);
	'change .ins-file-input': (event, template)->
		InstanceManager.uploadAttach(event.target.files, false)

		$(".ins-file-input").val('')
