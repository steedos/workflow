db.organizations = new Meteor.Collection('organizations')


db.organizations._simpleSchema = new SimpleSchema
	space: 
		type: String,
		optional: true,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");
	name:
		type: String,
		max: 200
	parent:
		type: String,
		optional: true,
		autoform:
			type: "selectorg"
	sort_no: 
		type: Number,
		optional: true,
		autoform: 
			omit: true
	users: 
		type: [String],
		optional: true,
		autoform: 
			omit: true,
			type: "select",
			afFieldInput: 
				multiple: true
			options: ->
				options = []
				selector = {}
				if Session.get("spaceId")
					selector = {space: Session.get("spaceId")}

				objs = db.space_users.find(selector, {name:1, sort: {name:1}})
				objs.forEach (obj) ->
					options.push
						label: obj.name,
						value: obj.user
				return options
	is_company: 
		type: Boolean,
		optional: true,
		autoform: 
			omit: true
	parents: 
		type: [String],
		optional: true,
		autoform: 
			omit: true
	fullname: 
		type: String,
		optional: true,
		autoform: 
			omit: true
	children:
		type: [String],
		optional: true,
		autoform: 
			omit: true
	created:
		type: Date,
		optional: true
	created_by:
		type: String,
		optional: true
	modified:
		type: Date,
		optional: true
	modified_by:
		type: String,
		optional: true

if Meteor.isClient
	db.organizations._simpleSchema.i18n("organizations")

db.organizations.attachSchema db.organizations._simpleSchema;


db.organizations.helpers

	calculateParents: ->
		parents = [];
		if (!this.parent)
			return parents
		parentId = this.parent;
		while (parentId)
			parents.push(parentId)
			parentOrg = db.organizations.findOne({_id: parentId}, {parent: 1, name: 1});
			if (parentOrg)
				parentId = parentOrg.parent
		return parents


	calculateFullname: ->
		fullname = this.name;
		if (!this.parent)
			return fullname;
		parentId = this.parent;
		while (parentId)
			parentOrg = db.organizations.findOne({_id: parentId}, {parent: 1, name: 1});
			fullname = parentOrg.name + "/" + fullname;
			parentId = parentOrg.parent
		return fullname


	calculateChildren: ->
		children = []
		childrenObjs = db.organizations.find({parent: this._id}, {fields: {_id:1}});
		childrenObjs.forEach (child) ->
			children.push(child._id);
		return children;

	updateUsers: ->
		users = []
		spaceUsers = db.space_users.find({organizations: this._id}, {fields: {user:1}});
		spaceUsers.forEach (user) ->
			users.push(user.user);
		db.organizations.direct.update({_id: this._id}, {$set: {users: users}})

	space_name: ->
		space = db.spaces.findOne({_id: this.space});
		return space?.name

	users_count: ->
		if this.users
			return this.users.length
		else 
			return 0
		

if (Meteor.isServer) 

	db.organizations.before.insert (userId, doc) ->
		doc.created_by = userId;
		doc.created = new Date();
		doc.modified_by = userId;
		doc.modified = new Date();
		#doc.is_company = !doc.parent;
		if (!doc.space)
			throw new Meteor.Error(400, "organizations_error_space_required");
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, "organizations_error_space_not_found");
		# only space admin can update space_users
		if userId and space.admins.indexOf(userId) < 0
			throw new Meteor.Error(400, "organizations_error_space_admins_only");
		if doc.users
			throw new Meteor.Error(400, "organizations_error_users_readonly");

		# 同一个space中不能有同名的organization，parent 不能有同名的 child
		if doc.parent
			parentOrg = db.organizations.findOne(doc.parent)
			if parentOrg.children
				nameOrg = db.organizations.find({_id: {$in: parentOrg.children}, name: doc.name}).count()
				if nameOrg>0
					throw new Meteor.Error(400, "organizations_error_organizations_name_exists") 
		else
			# 新增部门时不允许创建根部门
			broexisted = db.organizations.find({space:doc.space}).count()
			if broexisted > 0
				throw new Meteor.Error(400, "organizations_error_organizations_parent_required")

			orgexisted = db.organizations.find({name: doc.name, space: doc.space,fullname:doc.name}).count()				
			if orgexisted > 0
				throw new Meteor.Error(400, "organizations_error_organizations_name_exists")

		

	db.organizations.after.insert (userId, doc) ->
		updateFields = {}
		obj = db.organizations.findOne(doc._id)
		
		updateFields.parents = obj.calculateParents();
		updateFields.fullname = obj.calculateFullname()

		if !_.isEmpty(updateFields)
			db.organizations.direct.update(obj._id, {$set: updateFields})

		if doc.parent
			parent = db.organizations.findOne(doc.parent)
			db.organizations.direct.update(parent._id, {$set: {children: parent.calculateChildren()}});


	db.organizations.before.update (userId, doc, fieldNames, modifier, options) ->
		modifier.$set = modifier.$set || {};
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, "organizations_error_space_not_found");
		# only space admin can update space_users
		if space.admins.indexOf(userId) < 0
			throw new Meteor.Error(400, "organizations_error_space_admins_only");

		if (modifier.$set.space and doc.space!=modifier.$set.space)
			throw new Meteor.Error(400, "organizations_error_space_readonly");

		if (modifier.$set.parents)
			throw new Meteor.Error(400, "organizations_error_parents_readonly");

		if (modifier.$set.children)
			throw new Meteor.Error(400, "organizations_error_children_readonly");

		if (modifier.$set.fullname)
			throw new Meteor.Error(400, "organizations_error_fullname_readonly");

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();

		if modifier.$set.users
			throw new Meteor.Error(400, "organizations_error_users_readonly");
								
		if (modifier.$set.parent)
			# parent 不能等于自己或者 children
			parentOrg = db.organizations.findOne({_id: modifier.$set.parent})
			if (doc._id == parentOrg._id || parentOrg.parents.indexOf(doc._id)>=0)
				throw new Meteor.Error(400, "organizations_error_parent_is_self")
			# 同一个 parent 不能有同名的 child
			if parentOrg.children
				nameOrg = db.organizations.find({_id: {$in: parentOrg.children}, name: modifier.$set.name}).count()
				if (nameOrg > 0 ) && (modifier.$set.name != doc.name)
					throw new Meteor.Error(400, "organizations_error_organizations_name_exists")
				
		# else if (modifier.$set.name != doc.name)					
		# 	existed = db.organizations.find({name: modifier.$set.name, space: doc.space,fullname:modifier.$set.name}).count()				
		# 	if existed > 0
		# 		throw new Meteor.Error(400, "organizations_error.organizations_name_exists"))

		# 根部门名字无法修改
		if modifier.$set.name != doc.name && (doc.is_company == true)
			throw new Meteor.Error(400, "organizations_error_organization_is_company")
		

	db.organizations.after.update (userId, doc, fieldNames, modifier, options) ->
		updateFields = {}
		obj = db.organizations.findOne(doc._id)
		if obj.parent
			updateFields.parents = obj.calculateParents();
		# 更新上级部门的children
		if (modifier.$set.parent)
			newParent = db.organizations.findOne(doc.parent)
			db.organizations.direct.update(newParent._id, {$set: {children: newParent.calculateChildren()}});
			# 如果更改 parent，更改前的对象需要重新生成children
			oldParent = db.organizations.find({children:doc._id});
			oldParent.forEach (organization) ->
				existed = db.organizations.find({_id:doc._id,parent:organization._id}).count()
				if (existed == 0)
					db.organizations.direct.update({_id:organization._id},{$pull:{children:doc._id}})


		# 如果更改 parent 或 name, 需要更新 自己和孩子们的 fullname	
		if (modifier.$set.parent || modifier.$set.name)
			updateFields.fullname = obj.calculateFullname()
			children = db.organizations.find({parents: doc._id});
			children.forEach (child) ->
				db.organizations.direct.update(child._id, {$set: {fullname: child.calculateFullname()}})

		if !_.isEmpty(updateFields)
			db.organizations.direct.update(obj._id, {$set: updateFields})

	
	db.organizations.before.remove (userId, doc) ->
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, "organizations_error_space_not_found");
		# only space admin can remove space_users
		if space.admins.indexOf(userId) < 0
			throw new Meteor.Error(400, "organizations_error_space_admins_only");

		# can not delete organization with children
		if (doc.children && doc.children.length>0)
			throw new Meteor.Error(400, "organizations_error_organization_has_children");

		if (doc.is_company)
			throw new Meteor.Error(400, "organizations_error_can_not_remove_root_organization");


	db.organizations.after.remove (userId, doc) ->
		if (doc.parent)
			parent = db.organizations.findOne(doc.parent)
			db.organizations.direct.update(parent._id, {$set: {children: parent.calculateChildren()}});

		# !!! If delete organization, a lot of data need delete.
		# if doc.users
		#	_.each doc.users, (userId) ->
		#		db.space_users.direct.update({user: userId}, {$unset: {organization: 1}})

	
	Meteor.publish 'organizations', (spaceId)->
		
		unless this.userId
			return this.ready()
		
		unless spaceId
			return this.ready()

		user = db.users.findOne(this.userId);

		selector = 
			space: spaceId

		console.log '[publish] organizations ' + spaceId

		return db.organizations.find(selector)

	Meteor.publish 'my_organizations', (spaceId)->
		
		unless this.userId
			return this.ready()
		
		unless spaceId
			return this.ready()

		console.log '[publish] my_organizations ' + spaceId

		return db.organizations.find({space: spaceId, users: this.userId})
