Template.steedos_contacts_tree.helpers 


Template.steedos_contacts_tree.onRendered ->
  $(document.body).addClass('loading');
  # 防止首次加载时，获得不到node数据。
  # Steedos.subsSpace.subscribe 'organizations', Session.get("spaceId"), onReady: ->
  # this.autorun ()->
  #   if Steedos.subsSpace.ready("organizations")
  console.log "loaded_organizations ok...";
  $("#steedos_contacts_organizations_tree").on('changed.jstree', (e, data) ->
        if data.selected.length
          console.log 'The selected node is::: ' + data.instance.get_node(data.selected[0]).text
          Session.set("contact_showBooks", false)
          Session.set("contacts_orgId", data.selected[0]);
        return
      ).jstree
            core: 
                themes: { "stripes" : true },
                data:  (node, cb) ->
                  Session.set("contacts_orgId", node.id);
                  cb(ContactsManager.getOrgNode(node));
                      
            plugins: ["wholerow", "search"]
  this.autorun ()->
    if Steedos.subsSpace.ready("address_groups")
      $("#steedos_contacts_books_tree").on('changed.jstree', (e, data) ->
            if data.selected.length
              console.log 'The selected node is: ' + data.instance.get_node(data.selected[0]).text
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



Template.steedos_contacts_tree.events
  'click #search-btn': (event, template) ->
    console.log 'click search-btn'
    $('#organizations_tree').jstree(true).search($("#search-key").val());
    $('#books_tree').jstree(true).search($("#search-key").val());

  'click #steedos_contacts_tree_org_add_btn': (event, template) ->
    AdminDashboard.modalNew 'organizations', ()->
      $.jstree.reference('#steedos_contacts_organizations_tree').refresh()

  'click #steedos_contacts_tree_org_edit_btn': (event, template) ->
    AdminDashboard.modalEdit 'organizations', Session.get('contacts_orgId'), ()->
      $.jstree.reference('#steedos_contacts_organizations_tree').refresh()

  'click #steedos_contacts_tree_org_remove_btn': (event, template) ->
    AdminDashboard.modalDelete 'organizations', Session.get('contacts_orgId'), ()->
      $.jstree.reference('#steedos_contacts_organizations_tree').refresh()
