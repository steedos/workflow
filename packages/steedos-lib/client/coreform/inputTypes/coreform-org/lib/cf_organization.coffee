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

  CFDataManager.setOrganizationModalValue(CFDataManager.getFormulaOrganizations(@data.defaultValues));

  $.jstree.defaults.checkbox.three_state = false;

  $(document.body).addClass('loading');

  plugins = ["wholerow", "conditionalselect"];

  Template.cf_organization.multiple = this.data.multiple;

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
                three_state: false
            conditionalselect: (node) ->
              return Template.cf_organization.conditionalselect(node);

            plugins: plugins
      $(document.body).removeClass('loading');


Template.cf_organization.events
