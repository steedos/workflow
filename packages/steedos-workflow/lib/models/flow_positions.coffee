db.flow_positions = new Meteor.Collection('flow_positions')

db.flow_positions._simpleSchema = new SimpleSchema
	space: 
		type: String,
		optional: true,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");
	role: 
		type: String,
		autoform:
			foreign_key: true,
			references: {
				collection: 'flow_roles',
				key: '_id',
				search_keys: ['name']
			}
			type: "select",
			options: ->
				options = []
				selector = {}
				selector.space = Session.get('spaceId')
				objs = WorkflowManager.remoteFlowRoles.find(selector, {fields: {name:1} })
				objs.forEach (obj) ->
					options.push
						label: obj.name,
						value: obj._id
				return options
	users: 
		type: [String],
		autoform:
			type: "selectuser"
			multiple: true,
			foreign_key: true,
			references: {
				collection: 'space_users'
				key: 'user',
			}

	org: 
		type: String,
		autoform: 
			type: "selectorg",
			foreign_key: true,
			references: {
				collection: 'organizations'
			}


if Meteor.isClient
	db.flow_positions._simpleSchema.i18n("flow_positions")

db.flow_positions.attachSchema(db.flow_positions._simpleSchema)


db.flow_positions.helpers

	role_name: ->
		role = db.flow_roles.findOne({_id: this.role}, {fields: {name: 1}});
		return role && role.name;
	
	org_name: ->
		org = db.organizations.findOne({_id: this.org}, {fields: {fullname: 1}});
		return org && org.fullname;
	
	users_name: ->
		if (!this.users instanceof Array)
			return ""
		users = db.space_users.find({space: this.space, user: {$in: this.users}}, {fields: {name:1}});
		names = []
		users.forEach (user) ->
			names.push(user.name)
		return names.toString();


		
if Meteor.isServer

	db.flow_positions.allow
		insert: (userId, event) ->
			if (!Steedos.isSpaceAdmin(event.space, userId))
				return false
			else
				return true

		update: (userId, event) ->
			if (!Steedos.isSpaceAdmin(event.space, userId))
				return false
			else
				return true

		remove: (userId, event) ->
			if (!Steedos.isSpaceAdmin(event.space, userId))
				return false
			else
				return true

if Meteor.isServer

	db.flow_positions.before.insert (userId, doc) ->

		doc.created_by = userId;
		doc.created = new Date();

		if (!Steedos.isSpaceAdmin(doc.space, userId))
			throw new Meteor.Error(400, "error_space_admins_only");

	db.flow_positions.before.update (userId, doc, fieldNames, modifier, options) ->

		modifier.$set = modifier.$set || {};

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();

		if (!Steedos.isSpaceAdmin(doc.space, userId))
			throw new Meteor.Error(400, "error_space_admins_only");

	db.flow_positions.before.remove (userId, doc) ->

		if (!Steedos.isSpaceAdmin(doc.space, userId))
			throw new Meteor.Error(400, "error_space_admins_only");

if Meteor.isServer
	db.flow_positions._ensureIndex({
		"space": 1
	},{background: true})

	db.flow_positions._ensureIndex({
		"space": 1,
		"created": 1
	},{background: true})

	db.flow_positions._ensureIndex({
		"space": 1,
		"created": 1,
		"modified": 1
	},{background: true})

	db.flow_positions._ensureIndex({
		"role": 1,
		"org": 1,
		"space": 1
	},{background: true})

	db.flow_positions._ensureIndex({
		"space": 1,
		"users": 1
	},{background: true})

	db.flow_positions._ensureIndex({
		"space": 1,
		"role": 1
	},{background: true})

new Tabular.Table
	name: "flow_positions",
	collection: db.flow_positions,
	pub: "flow_positions_tabular",
	columns: [
		{data: "role_name()"},
		{data: "org_name()"},
		{data: "users_name()"},
		{
			data: "",
			title: "",
			orderable: false,
			width: '1px',
			render: (val, type, doc) ->
				return '<button type="button" class="btn btn-xs btn-default" id="edit"><i class="fa fa-pencil"></i></button>'
		},
		{
			data: "",
			title: "",
			orderable: false,
			width: '1px',
			render: (val, type, doc) ->
				return '<button type="button" class="btn btn-xs btn-default" id="remove"><i class="fa fa-times"></i></button>'
		}
	]
	extraFields: ["space", "role", "org", "users"]
	lengthChange: false
	ordering: false
	# 临时把pageLength改为1000【去掉翻页】，解决搜索不能正常工作时，QHD现场同事不方便查找数据的问题
	pageLength: 10
	info: false
	searching: true
	autoWidth: true
	changeSelector: (selector, userId) ->
		unless userId
			return {_id: -1}
		space = selector.space
		unless space
			if selector?.$and?.length > 0
				space = selector.$and.getProperty('space')[0]
		unless space
			return {_id: -1}
		space_user = db.space_users.findOne({user: userId, space: space}, {fields: {_id: 1}})
		unless space_user
			return {_id: -1}
		return selector