ContactsManager = {};

ContactsManager.organizationRemote = new AjaxCollection("organizations");

ContactsManager.getNode = function(node){
	console.log(node);

	var orgs ;

	if(node.id == '#')
		orgs = ContactsManager.getRoot();
	else
		orgs = ContactsManager.getChild(node.id);

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


ContactsManager.getRoot = function(){
	return ContactsManager.organizationRemote.find({parent:""}, {fields:{_id:1, name:1, parent:1, children:1, childrens:1}});
};


ContactsManager.getChild = function(parentId){
	return ContactsManager.organizationRemote.find({parent: parentId}, {fields:{_id:1, name:1, parent:1, children:1, childrens:1}});
}
