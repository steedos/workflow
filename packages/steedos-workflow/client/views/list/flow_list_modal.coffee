Template.flow_list_modal.helpers
    flow_list_data : ->
        return WorkflowManager.getFlowListData('show');

    empty: (categorie)->
        if !categorie.forms || categorie.forms.length < 1
            return false;
        return true;

    equals: (a, b)->
        return a==b;

    isChecked: (a)->
        return Session.get("flowId") == a;

    isChoose: (a)->
        return Session.get("categorie_id") == ("categories_" + a);

    getCategorieClass : (id)->
        if Session.get("categorie_id") == ("categories_" + id)
            return "in"

        return "";


Template.flow_list_modal.events

    'click .flow_list_modal .weui_cell': (event) ->
        flow = event.currentTarget.dataset.flow;

        Modal.hide('flow_list_modal');

        if !flow
            Session.set("flowId", undefined);
        else
            Session.set("flowId", flow);

        categorie = event.currentTarget.parentElement.parentElement.id;

        if !categorie
            Session.set("categorie_id", undefined);
        else
            Session.set("categorie_id", categorie);

    'click #export_filter_help': (event, template) ->
        Steedos.openWindow(t("export_filter_help"));
