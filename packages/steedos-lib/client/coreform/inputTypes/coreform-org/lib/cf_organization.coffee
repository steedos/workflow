Template.cf_organization.helpers 


Template.cf_organization.onRendered ->
  $(document.body).addClass('loading');
  # 防止首次加载时，获得不到node数据。
  # Steedos.subsSpace.subscribe 'organizations', Session.get("spaceId"), onReady: ->
  console.log("cf_organization.onRendered...");
  plugins = ["wholerow"];

  if this.data.multiple
    plugins.push("checkbox");


  this.autorun ()->
    if Steedos.subsSpace.ready("organizations")
      # console.log "loaded_organizations ok...";
      $("#organizations_tree").on('changed.jstree', (e, data) ->
            # console.log(data);
            if data.selected.length
              # console.log 'The selected node is: ' + data.instance.get_node(data.selected[0]).text
              Session.set("cf_selectOrgId", data.selected[0]);
            return
          ).jstree
                core: 
                    themes: { "stripes" : true },
                    data:  (node, cb) ->
                      Session.set("cf_selectOrgId", node.id);
                      cb(CFDataManager.getNode(node));
                          
                plugins: plugins

      $(document.body).removeClass('loading');



Template.cf_organization.events