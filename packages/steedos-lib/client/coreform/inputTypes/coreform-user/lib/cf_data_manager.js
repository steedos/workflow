CFDataManager = {};

// DataManager.organizationRemote = new AjaxCollection("organizations");
// DataManager.spaceUserRemote = new AjaxCollection("space_users");
// DataManager.flowRoleRemote = new AjaxCollection("flow_roles");
CFDataManager.getNode = function(node) {
  // console.log(node);

  var orgs;

  if (node.id == '#')
    orgs = CFDataManager.getRoot();
  else
    orgs = CFDataManager.getChild(node.id);

  return handerOrg(orgs);
}


function handerOrg(orgs) {

  var nodes = new Array();

  orgs.forEach(function(org) {

    var node = new Object();

    node.text = org.name;

    node.data = {};

    node.data.fullname = org.fullname;

    node.id = org._id;

    node.state = {};

    if (CFDataManager.getOrganizationModalValue().getProperty("id").includes(node.id)) {
      node.state.selected = true;
    }

    if (org.children && org.children.length > 0) {
      node.children = true;
    }

    if (org.parent != '') {
      node.parent = org.parent;
      node.icon = false; //node.icon = "fa fa-users";
    } else {
      node.state.opened = true;
      node.icon = 'fa fa-sitemap';
    }

    nodes.push(node);
  });

  return nodes;
}



CFDataManager.setContactModalValue = function(value) {
  $("#cf_contact_modal").data("values", value);
  if(value && value instanceof Array){
    TabularTables.cf_tabular_space_user.customData.defaultValues = value.getProperty("id");
  }
}

CFDataManager.getContactModalValue = function() {
  var value = $("#cf_contact_modal").data("values");
  return value ? value : new Array();
}

CFDataManager.setOrganizationModalValue = function(value) {
  $("#cf_organization_modal").data("values", value);
}

CFDataManager.getOrganizationModalValue = function() {
  var value = $("#cf_organization_modal").data("values");
  return value ? value : new Array();
}

CFDataManager.getSelectedModalValue = function() {
  var val = new Array();
  var instance = $('#organizations_tree').jstree(true);
  var checked = instance.get_selected();

  checked.forEach(function(id) {
    var node = instance.get_node(id);
    val.push({
      id: id,
      name: node.text
    });
  });

  return val;
}


CFDataManager.getCheckedValues = function() {
  var values = new Array();
  $('[name=\'contacts_ids\']').each(function() {
    if (this.checked) {
      values.push({
        id: this.value,
        name: this.dataset.name
      });
    }
  });

  return values;
}


CFDataManager.handerContactModalValueLabel = function() {

  var values = CFDataManager.getContactModalValue();
  var modal = $(".cf_contact_modal");

  var confirmButton, html = '',
    valueLabel, valueLabel_div;

  confirmButton = $('#confirm', modal);

  valueLabel = $('#valueLabel', modal);

  valueLabel_div = $('#valueLabel_div', modal);

  valueLabel_ui = $('#valueLabel_ui', modal);

  if (values.length > 0) {
    values.forEach(function(v) {
      return html = html + '\u000d\n<li data-value=' + v.id + ' data-name=' + v.name + '>' + v.name + '</li>';
    });
    valueLabel.html(html);

    if (valueLabel_ui.height() > 46) {
      valueLabel_ui.css("white-space", "nowrap");
    } else {
      valueLabel_ui.css("white-space", "initial");
    }

    Sortable.create(valueLabel[0], {
      group: 'words',
      animation: 150,
      onRemove: function(event) {
        return console.log('onRemove...');
      },
      onEnd: function(event) {
        var labelValues;
        labelValues = [];
        $('#valueLabel li').each(function() {
          return labelValues.push({
            id: this.dataset.value,
            name: this.dataset.name
          });
        });
        CFDataManager.setContactModalValue(labelValues);
      }
    });

    valueLabel_div.show();
    confirmButton.html(confirmButton.prop("title") + " ( " + values.length + " ) ");
  } else {
    confirmButton.html(confirmButton.prop("title"));
    valueLabel_div.hide();
  }
}

CFDataManager.handerOrganizationModalValueLabel = function() {

  var values = CFDataManager.getOrganizationModalValue();
  var modal = $(".cf_organization_modal");

  var confirmButton, html = '',
    valueLabel, valueLabel_div;

  confirmButton = $('#confirm', modal);

  valueLabel = $('#valueLabel', modal);

  valueLabel_div = $('#valueLabel_div', modal);

  valueLabel_ui = $('#valueLabel_ui', modal);

  if (values.length > 0) {
    values.forEach(function(v) {
      return html = html + '\u000d\n<li data-value=' + v.id + ' data-name=' + v.name + '>' + v.name + '</li>';
    });
    valueLabel.html(html);

    if (valueLabel_ui.height() > 46) {
      valueLabel_ui.css("white-space", "nowrap");
    } else {
      valueLabel_ui.css("white-space", "initial");
    }

    Sortable.create(valueLabel[0], {
      group: 'words',
      animation: 150,
      onRemove: function(event) {
        return console.log('onRemove...');
      },
      onEnd: function(event) {
        var labelValues;
        labelValues = [];
        $('#valueLabel li').each(function() {
          return labelValues.push({
            id: this.dataset.value,
            name: this.dataset.name
          });
        });
        CFDataManager.setOrganizationModalValue(labelValues);
      }
    });

    valueLabel_div.show();
    confirmButton.html(confirmButton.prop("title") + " ( " + values.length + " ) ");
  } else {
    confirmButton.html(confirmButton.prop("title"));
    valueLabel_div.hide();
  }
}


CFDataManager.getRoot = function() {
  return SteedosDataManager.organizationRemote.find({
    is_company: true
  }, {
    fields: {
      _id: 1,
      name: 1,
      fullname: 1,
      parent: 1,
      children: 1,
      childrens: 1
    }
  });
};


CFDataManager.getChild = function(parentId) {
  return SteedosDataManager.organizationRemote.find({
    parent: parentId
  }, {
    fields: {
      _id: 1,
      name: 1,
      fullname: 1,
      parent: 1,
      children: 1,
      childrens: 1
    }
  });
}


CFDataManager.getSpaceUser = function(userId) {
  if (!userId) {
    return;
  }

  if (typeof userId != "string") {

    return this.getSpaceUsers(userId);

  }

  var spaceUsers = SteedosDataManager.getSpaceUsers(Session.get('spaceId'), userId);
  if (!spaceUsers) {
    return
  };

  var spaceUser = spaceUsers[0];
  if (!spaceUser) {
    return
  };

  return spaceUser;
};

CFDataManager.getSpaceUsers = function(userIds) {

  if ("string" == typeof(userIds)) {
    return [CFDataManager.getSpaceUser(userIds)]
  }

  var users = new Array();
  if (userIds) {
    users = SteedosDataManager.getSpaceUsers(Session.get('spaceId'), userIds);
  }

  return users;
};

CFDataManager.getFormulaSpaceUsers = function(userIds) {
  if (!userIds)
    return;
  return CFDataManager.getFormulaSpaceUser(userIds);
}

//return {name:'',organization:{fullname:'',name:''},roles:[]}
CFDataManager.getFormulaSpaceUser = function(userId) {

  if (userId instanceof Array) {
    return SteedosDataManager.getFormulaUserObjects(Session.get('spaceId'), userId);
  } else {
    return SteedosDataManager.getFormulaUserObjects(Session.get('spaceId'), [userId])[0];
  }
};

CFDataManager.getOrgAndChild = function(orgId) {
  var childrens = SteedosDataManager.organizationRemote.find({
    parents: orgId
  }, {
    fields: {
      _id: 1
    }
  });
  orgs = childrens.getProperty("_id");
  orgs.push(orgId);
  return orgs;
}


CFDataManager.getFormulaOrganizations = function(orgIds) {
  if (!orgIds)
    return;
  var orgs = new Array();
  if (orgIds instanceof Array) {
    orgIds.forEach(function(orgId) {
      orgs.push(CFDataManager.getFormulaOrganization(orgId));
    });

  } else {
    orgs = CFDataManager.getFormulaOrganization(orgIds);
  }

  return orgs;
}

CFDataManager.getFormulaOrganization = function(orgId) {
  var org = SteedosDataManager.organizationRemote.findOne({
    _id: orgId
  }, {
    fields: {
      _id: 1,
      name: 1,
      fullname: 1
    }
  });
  org.id = org._id;
  delete org._id;
  return org;
}
