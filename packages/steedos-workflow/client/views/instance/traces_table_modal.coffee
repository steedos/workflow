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


Template.traces_table_modal.onCreated ->
	self = this;

	self.maxHeight = new ReactiveVar(
		$(window).height());

	$(window).resize ->
		self.maxHeight?.set($(window).height());

Template.traces_table_modal.onRendered ->
	$("body").removeClass("loading")
	Modal.allowMultiple = true

	self = this;

	self.maxHeight?.set($(window).height());


Template.traces_table_modal.onDestroyed ->
	Modal.allowMultiple = false