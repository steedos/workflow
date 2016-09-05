Template.contacts_tree.helpers 


Template.contacts_tree.onRendered ->
  $(document.body).addClass('loading');
  # 防止首次加载时，获得不到node数据。
  # Steedos.subsSpace.subscribe 'organizations', Session.get("spaceId"), onReady: ->
  this.autorun ()->
    if Session.get("loaded_organizations")
      console.log "loaded_organizations ok...";
      $("#contacts_tree").on('changed.jstree', (e, data) ->
            if data.selected.length
              console.log 'The selected node is: ' + data.instance.get_node(data.selected[0]).text
              Session.set("contacts_orgId", data.selected[0]);
            return
          ).jstree
                core: 
                    themes: { "stripes" : true },
                    data:  (node, cb) ->
                      Session.set("contacts_orgId", node.id);
                      cb(ContactsManager.getNode(node));
                          
                plugins: ["wholerow"]

      $(document.body).removeClass('loading');



Template.contacts_tree.events