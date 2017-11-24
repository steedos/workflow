Template.cf_organization.helpers


Template.cf_organization.conditionalselect = (node)->
  if Template.cf_organization.multiple
    values = CFDataManager.getOrganizationModalValue();

    if node.state.selected
      values.remove(values.getProperty("id").indexOf(node.id))
    else
      if values.getProperty("id").indexOf(node.id) < 0
        values.push({id: node.id, name: node.text, fullname: node.data.fullname});

    CFDataManager.setOrganizationModalValue(values);
    CFDataManager.handerOrganizationModalValueLabel();
  else
    CFDataManager.setOrganizationModalValue([{id: node.id, name: node.text, fullname: node.data.fullname}]);
    $("#confirm", $("#cf_organization_modal")).click()

  return true;


Template.cf_organization.onRendered ->
  spaceId = Template.instance().data.spaceId
  CFDataManager.setOrganizationModalValue(CFDataManager.getFormulaOrganizations(@data.defaultValues, spaceId));

  $.jstree.defaults.checkbox.three_state = false;

  plugins = ["wholerow", "conditionalselect"];

  Template.cf_organization.multiple = this.data.multiple;

  if this.data.multiple
    plugins.push("checkbox");

  $("#cf_organizations_tree").on('changed.jstree', (e, data) ->
    if data.selected.length
      Session.set("cf_selectOrgId", data.selected[0]);

      if data?.node?.parent=="#" && data?.node?.state?.opened
        return ;

      $("#cf_organizations_tree").jstree('toggle_node', data.node?.id);
    return
  ).jstree
        core:
            themes: { "stripes" : true },
            data:  (node, cb) ->
              Session.set("cf_selectOrgId", node.id);
              cb(CFDataManager.getNode(spaceId, node));
            three_state: false
        conditionalselect: (node) ->
          return Template.cf_organization.conditionalselect(node);

        plugins: plugins

Template.cf_organization.events
