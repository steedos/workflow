CFDataManager = {};

// DataManager.organizationRemote = new AjaxCollection("organizations");
// DataManager.spaceUserRemote = new AjaxCollection("space_users");
// DataManager.flowRoleRemote = new AjaxCollection("flow_roles");
CFDataManager.getNode = function(node){
    // console.log(node);

    var orgs ;

    if(node.id == '#')
        orgs = CFDataManager.getRoot();
    else
        orgs = CFDataManager.getChild(node.id);

    return handerOrg(orgs);
}


function handerOrg(orgs){

    var nodes = new Array();

    orgs.forEach(function(org){

        var node = new Object();

        node.text = org.name;

        node.id = org._id;
        
        if(org.children && org.children.length > 0){
            node.children = true;
        }

        if(org.parent != ''){
            node.parent = org.parent;
            node.icon = false; //node.icon = "fa fa-users";
        }else{
            node.state = {opened:true};
            node.icon = 'fa fa-sitemap';
        }

        nodes.push(node);
    });

    return nodes;
}


CFDataManager.setContactModalValue = function(value){
    $("#cf_contact_modal").data("values",value);
}

CFDataManager.getContactModalValue = function(){
    var value = $("#cf_contact_modal").data("values");
    return value? value : new Array();
}

CFDataManager.getCheckedValues = function(){
    var values = new Array();
    $('[name=\'contacts_ids\']').each(function() {
      if (this.checked) {
        values.push({id: this.value, name: this.dataset.name});
      }
    });

    return values;
}


CFDataManager.handerValueLabel = function(values){
    
    var values = CFDataManager.getContactModalValue();

    var confirmButton, html = '', valueLabel, valueLabel_div;

    confirmButton = $('#confirm', $(".cf_contact_modal"));

    valueLabel = $('#valueLabel', $(".cf_contact_modal"));

    valueLabel_div = $('#valueLabel_div', $(".cf_contact_modal"));

    if (values.length > 0) {
        values.forEach(function(v) {
            return html = html + '\u000d\n<li data-value=' + v.id + ' data-name=' + v.name + '>' + v.name + '</li>';
        });
        valueLabel.html(html);
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


CFDataManager.getRoot = function(){
    return SteedosDataManager.organizationRemote.find({parent:""}, {fields:{_id:1, name:1, parent:1, children:1, childrens:1}});
};


CFDataManager.getChild = function(parentId){
    return SteedosDataManager.organizationRemote.find({parent: parentId}, {fields:{_id:1, name:1, parent:1, children:1, childrens:1}});
}


CFDataManager.getSpaceUser = function (userId){
  if (!userId) {
    return ;
  }

  if (typeof userId != "string"){

    return this.getSpaceUsers(userId);
  
  }

  var spaceUsers = SteedosDataManager.getSpaceUsers(Session.get('spaceId'), userId);
  if(!spaceUsers){ return };

  var spaceUser = spaceUsers[0];
  if(!spaceUser){ return };

  return spaceUser;
};

CFDataManager.getSpaceUsers = function (userIds){

  if("string" == typeof(userIds)){
    return [this.getUser(userIds)]
  }

  var users = new Array();
  if(userIds){
    users = SteedosDataManager.getSpaceUsers(Session.get('spaceId'), userIds);
  }

  return users;
};

CFDataManager.getFormulaSpaceUsers = function(userIds){
  if (!userIds)
    return ;
  if(userIds instanceof Array){
    var users = new Array();
    userIds.forEach(function(u){
      var user = CFDataManager.getFormulaSpaceUser(u);
      if(u)
        users.push(user);
    });
    return users;
  }else{
    return CFDataManager.getFormulaSpaceUser(userIds);
  }
}

//return {name:'',organization:{fullname:'',name:''},roles:[]}
CFDataManager.getFormulaSpaceUser = function(userId){
  var userObject = {};

  var user = WorkflowManager.getUser(userId);

  if(!user || !user.hasOwnProperty("name"))
    return null;

  userObject['id'] = userId;
  userObject['name'] = user.name;
  userObject['organization'] = {'name':user.organization.name,'fullname':user.organization.fullname};
  userObject["roles"] = user.roles ? user.roles.getProperty('name'):[];

  return userObject;

};
