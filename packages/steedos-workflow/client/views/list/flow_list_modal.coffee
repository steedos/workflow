Template.flow_list_modal.helpers
	flow_list_data: ->
		showType = Template.instance().data?.showType
		return WorkflowManager.getFlowListData(showType);

	empty: (categorie)->
		if !categorie.forms || categorie.forms.length < 1
			return false;
		return true;

	equals: (a, b)->
		return a == b;

	isChecked: (a)->
		flowId = Template.instance().data?.flowId
		if !flowId
			flowId = Session.get("flowId")
		return flowId == a;

	isChoose: (a)->
		return Session.get("categorie_id") == ("categories_" + a);

	getCategorieClass: (id)->
		if Session.get("categorie_id") == ("categories_" + id)
			return "in"

		return "";

	title: ()->
        title = Template.instance().data?.title
        if title
            return title
        else
            return t "workflow_export_filter"


Template.flow_list_modal.events

	'click .flow_list_modal .weui_cell': (event, template) ->

		flow = event.currentTarget.dataset.flow;
		categorie = event.currentTarget.parentElement.parentElement.id;
		Modal.hide('flow_list_modal');

		
		if template.data?.callBack && _.isFunction(template.data.callBack)
			template.data.callBack flow:flow, categorie: categorie

		# if template.data?.onSelected && _.isFunction(template.data.onSelected)
		# 	template.data.onSelected(flow, categorie)
		# else
		# 	if !flow
		# 		Session.set("flowId", undefined);
		# 	else
		# 		Session.set("flowId", flow);

		# 	if !categorie
		# 		Session.set("categorie_id", undefined);
		# 	else
		# 		Session.set("categorie_id", categorie);

	'hide.bs.modal #flow_list_box': (event, template) ->
		Modal.allowMultiple = false;
		return true;

'click #export_filter_help': (event, template) ->
	Steedos.openWindow(t("export_filter_help"));
