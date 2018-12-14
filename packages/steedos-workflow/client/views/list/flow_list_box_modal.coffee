Template.flow_list_box_modal.helpers
	title: ()->
		title = Template.instance().data?.title
		if title
			return title
		else
			return t "Fill in form"


Template.flow_list_box_modal.onRendered ->

Template.flow_list_box_modal.events
	'click #new_help': (event, template) ->
		Steedos.openWindow(t("new_help"));

	'hide.bs.modal #flow_list_box_modal': (event, template) ->
		Modal.allowMultiple = false;
		return true;