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
			type: "select",
			options: ->
				options = []
				selector = {}
				objs = db.flow_roles.find(selector, {name:1, sort: {name:1}})
				objs.forEach (obj) ->
					options.push
						label: obj.name,
						value: obj._id
				return options
	users: 
		type: [String],
		autoform:
			type: "selectuser"
			multiple: true

	org: 
		type: String,
		autoform: 
			type: "selectorg"


if Meteor.isClient
	db.flow_positions._simpleSchema.i18n("flow_positions")

db.flow_positions.attachSchema(db.flow_positions._simpleSchema)


db.flow_positions.helpers

	role_name: ->
		role = db.flow_roles.findOne({_id: this.role});
		return role && role.name;
	
	org_name: ->
		org = db.organizations.findOne({_id: this.org});
		return org && org.fullname;
	
	users_name: ->
		if (!this.users instanceof Array)
			return ""
		users = db.space_users.find({user: {$in: this.users}}, {fields: {name:1}});
		names = []
		users.forEach (user) ->
			names.push(user.name)
		return names.toString();


		
if Meteor.isServer

	db.flow_positions.before.insert (userId, doc) ->

		doc.created_by = userId;
		doc.created = new Date();

		if !doc.space
			throw new Meteor.Error(400, "space_users_error.space_required");


	db.flow_positions.before.update (userId, doc, fieldNames, modifier, options) ->

		modifier.$set = modifier.$set || {};

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();

