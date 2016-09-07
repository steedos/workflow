ContactsManager = {};

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
	return db.organizations.find({parent:""}).fetch();
};


ContactsManager.getChild = function(parentId){
	return db.organizations.find({parent: parentId}).fetch();
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