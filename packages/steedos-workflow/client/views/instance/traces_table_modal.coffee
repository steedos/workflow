Template.traces_table_modal.helpers
	instance: ->
		Session.get("change_date")
		if (Session.get("instanceId"))
			steedos_instance = WorkflowManager.getInstance();
			return steedos_instance;

	maxHeight: ->
		return Template.instance()?.maxHeight.get() - 200 + 'px'

	traces_list_template: ->
		steedos_instance = WorkflowManager.getInstance();
		if InstanceManager.isTableStyle(steedos_instance.form)
			return 'instance_traces_table'
		else
			return 'instance_traces'

	traces_modal_calss: ->
		steedos_instance = WorkflowManager.getInstance();
		if InstanceManager.isTableStyle(steedos_instance.form)
			return 'traces_table_modal'
		else
			return 'traces_modal'

	tracesListData: (instance)->
		return instance.allTraces || instance.traces


Template.traces_table_modal.onCreated ->

	$("body").addClass("loading")

	Steedos.subs["instance_data"].subscribe("instance_data", Session.get("instanceId"), true)

	Tracker.autorun (c) ->
		if Steedos.subs["instance_data"].ready()
			$("body").removeClass("loading")

	self = this;

	self.maxHeight = new ReactiveVar(
		$(window).height());

	$(window).resize ->
		self.maxHeight?.set($(window).height());

Template.traces_table_modal.onRendered ->

	Modal.allowMultiple = true

	self = this;

	self.maxHeight?.set($(window).height());


Template.traces_table_modal.onDestroyed ->
	Modal.allowMultiple = false