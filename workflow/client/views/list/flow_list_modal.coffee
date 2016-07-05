Template.flow_list_modal.helpers
    flow_list_data : ->
        return WorkflowManager.getFlowListData();

    empty: (categorie)->
        if !categorie.forms || categorie.forms.length < 1
            return false;
        return true;

    equals: (a, b)->
        return a==b;

    isChecked: (a)->
        return Session.get("flowId") == a;



Template.flow_list_modal.events

    'click .flow_list_modal .weui_cell': (event) ->
        flow = event.currentTarget.dataset.flow;
        
        Modal.hide('flow_list_modal');  
        if !flow 
            Session.set("flowId", undefined);
        else    
            Session.set("flowId", flow);  
