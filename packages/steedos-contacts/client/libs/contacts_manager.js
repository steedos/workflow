ContactsManager = {};

ContactsManager.getOrgNode = function(node){
	console.log(node);

	var orgs ;

	if(node.id == '#')
		orgs = ContactsManager.getRoot();
	else
		orgs = ContactsManager.getChild(node.id);

	return handerOrg(orgs);
}

ContactsManager.getBookNode = function(node){
	var nodes = new Array();
	if(node.id == "#"){
		var n = new Object();
		n.text = "个人联系人";
		n.id = "parent";
		n.icon = 'ion ion-android-contacts';
		n.children = true;
		nodes.push(n);
	}else{
		var groups = db.address_groups.find().fetch();
		groups.forEach(function(g){
			var n = new Object();
			n.text = g.name;
			n.id = g._id;
			n.icon = false;
			nodes.push(n);
		});
	}

	return nodes;
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

		if(!org.is_company){
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


ContactsManager.getRoot = function(){
	return SteedosDataManager.organizationRemote.find({
	    is_company: true
	  }, {
	    fields: {
	      _id: 1,
	      name: 1,
	      fullname: 1,
	      parent: 1,
	      children: 1,
	      childrens: 1,
	      is_company:1
	    }
	  });
};


ContactsManager.getChild = function(parentId){
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

ContactsManager.getOrgAndChild = function(orgId) {
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

/*
* 查询当前部门及其自部门下的所有用户
*/
ContactsManager.getContacts = function(orgId){
	if(orgId == "#") return;

	var childrens = db.organizations.find({parents: orgId},{fields:{_id:1}}).fetch();

	orgs = childrens.getProperty("_id");
	
	orgs.push(orgId);

	page = 0

	page_size = 20;

	return db.space_users.find({organization: {$in: orgs}},{fields:{_id:1, name:1, email:1}, skip: page * page_size, limit: page_size}).fetch();
}

ContactsManager.getContactModalValue = function() {
  var value = $("#contacts_list").data("values");
  return value ? value : new Array();
}

ContactsManager.setContactModalValue = function(value) {
  $("#contacts_list").data("values", value);
}

ContactsManager.handerContactModalValueLabel = function() {

  var values = ContactsManager.getContactModalValue();
  var modal = $(".steedos-contacts");

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
        ContactsManager.setContactModalValue(labelValues);
      }
    });

    valueLabel_div.show();
    confirmButton.html(confirmButton.prop("title") + " ( " + values.length + " ) ");
  } else {
    confirmButton.html(confirmButton.prop("title"));
    valueLabel_div.hide();
  }
}