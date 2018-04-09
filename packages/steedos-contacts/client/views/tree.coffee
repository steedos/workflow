Template.contacts_tree.helpers 


Template.contacts_tree.onRendered ->
  $(document.body).addClass('loading');
  # 防止首次加载时，获得不到node数据。
  # Steedos.subsSpace.subscribe 'organizations', Session.get("spaceId"), onReady: ->
  # this.autorun ()->
  #   if Steedos.subsSpace.ready("organizations")
  $("#steedos_contacts_org_tree").on('changed.jstree', (e, data) ->
        if data.selected.length
          Session.set("contact_showBooks", false)
          Session.set("contacts_orgId", data.selected[0]);
        return
      ).jstree
            core: 
                themes: { "stripes" : true, "variant" : "large" },
                data:  (node, cb) ->
                  Session.set("contacts_orgId", node.id);
                  cb(ContactsManager.getOrgNode(node));
                      
            plugins: ["wholerow", "search"]
  this.autorun ()->
    if Steedos.subsSpace.ready("address_groups")
      $("#books_tree").on('changed.jstree', (e, data) ->
            if data.selected.length
              Session.set("contact_showBooks", true)
              Session.set("contacts_groupId", data.selected[0]);
            return
          ).jstree
                core: 
                    themes: { "stripes" : true },
                    data:  (node, cb) ->
                      Session.set("contacts_groupId", node.id);
                      cb(ContactsManager.getBookNode(node));
                          
                plugins: ["wholerow", "search"]

  $(document.body).removeClass('loading');



Template.contacts_tree.events
  'click #search-btn': (event, template) ->
    $('#steedos_contacts_org_tree').jstree(true).search($("#search-key").val());
    $('#books_tree').jstree(true).search($("#search-key").val());