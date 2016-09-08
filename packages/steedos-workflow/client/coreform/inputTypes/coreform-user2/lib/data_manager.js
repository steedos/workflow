DataManager = {};

DataManager.organizationRemote = new AjaxCollection("organizations");

DataManager.getNode = function(node){
	console.log(node);

	var orgs ;

	if(node.id == '#')
		orgs = DataManager.getRoot();
	else
		orgs = DataManager.getChild(node.id);

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


DataManager.getRoot = function(){
	return DataManager.organizationRemote.find({parent:""}, {fields:{_id:1, name:1, parent:1, children:1, childrens:1}});
};


DataManager.getChild = function(parentId){
	return DataManager.organizationRemote.find({parent: parentId}, {fields:{_id:1, name:1, parent:1, children:1, childrens:1}});
}
