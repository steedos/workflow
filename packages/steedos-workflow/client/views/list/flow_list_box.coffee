Template.flow_list_box.helpers
    flow_list_data : ->
        return WorkflowManager.getFlowListData();

    empty: (categorie)->
        if !categorie.forms || categorie.forms.length < 1
            return false;
        return true;

    equals: (a, b)->
        return a==b;



Template.flow_list_box.events

    'click .flow_list_box .weui_cell': (event) ->
        flow = event.currentTarget.dataset.flow;


        if !flow 
            return ;
        Modal.hide('flow_list_box_modal');    
        InstanceManager.newIns(flow);
        if Steedos.isMobile()
            # 手机上可能菜单展开了，需要额外收起来
            $("body").removeClass("sidebar-open")
