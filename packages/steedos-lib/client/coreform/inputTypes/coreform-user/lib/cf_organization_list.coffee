Template.cf_organization_list.helpers 


Template.cf_organization_list.onRendered ->
  $(document.body).addClass('loading');
  console.log "loaded_organizations ok...";
  $("#cf_organizations_tree").on('changed.jstree', (e, data) ->
        if data.selected.length
          # console.log 'The selected node is: ' + data.instance.get_node(data.selected[0]).text
          Session.set("cf_selectOrgId", data.selected[0]);
          Session.set("cf_orgAndChild", CFDataManager.getOrgAndChild(Session.get("cf_selectOrgId")));

          if data?.node?.parent=="#" && data?.node?.state?.opened
              return ;

          $("#cf_organizations_tree").jstree('toggle_node', data.selected[0]);

        return
      ).jstree
            core: 
                themes: { "stripes" : true , "variant" : "large"},
                three_state: false
                data:  (node, cb) ->
                  Session.set("cf_selectOrgId", node.id);
                  cb(CFDataManager.getNode(node));
                  Session.set("cf_orgAndChild", CFDataManager.getOrgAndChild(Session.get("cf_selectOrgId")));
                      
            plugins: ["wholerow"]

  $(document.body).removeClass('loading');



Template.cf_organization_list.events