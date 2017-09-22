db.instance_number_rules = new Meteor.Collection('instance_number_rules')

db.instance_number_rules._simpleSchema = new SimpleSchema
	space:
		type: String,
		autoform:
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");
	name:
		type: String
		autoform:
			type: "text"

	year:
		type: Number,
		optional: true,
		autoform:
			type: "coreform-number",
			readonly: true

	first_number:
		type: Number,
		optional: true,
		autoform:
			type: "coreform-number",
			defaultValue: ->
				return 1

	number:
		type: Number,
		optional: true,
		autoform:
			type: "coreform-number",
			defaultValue: ->
				return 0

	rules:
		type: String
		autoform:
			type: "text"


if Meteor.isClient
	db.instance_number_rules._simpleSchema.i18n("instance_number_rules")

db.instance_number_rules.attachSchema(db.instance_number_rules._simpleSchema)

if Meteor.isServer

	db.instance_number_rules.allow
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

	db.instance_number_rules.before.insert (userId, doc) ->
		doc.created_by = userId;
		doc.created = new Date();

		rules = db.instance_number_rules.findOne({space: doc.space, "name": doc.name})

		if rules
			throw new Meteor.Error(400, "instance_number_rules_name_only");

		if (!Steedos.isSpaceAdmin(doc.space, userId))
			throw new Meteor.Error(400, "error_space_admins_only");

		console.log userId + "; insert instance_number_rules",  doc

	db.instance_number_rules.before.update (userId, doc, fieldNames, modifier, options) ->

		modifier.$set = modifier.$set || {};

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();

#		if (!Steedos.isSpaceAdmin(doc.space, userId))
#			throw new Meteor.Error(400, "error_space_admins_only");

		console.log userId + "; update instance_number_rules",  doc

	db.instance_number_rules.before.remove (userId, doc) ->

		if (!Steedos.isSpaceAdmin(doc.space, userId))
			throw new Meteor.Error(400, "error_space_admins_only");

		console.log userId + "; remove instance_number_rules",  doc

new Tabular.Table
	name: "instance_number_rules",
	collection: db.instance_number_rules,
	columns: [
		{data: "name", title: "name"},
		{data: "year", title: "year"},
		{data: "first_number", title: "first_number"},
		{data: "number", title: "number"},
		{data: "rules", title: "rules"},
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
				return '<button type="button" class="btn btn-xs btn-default" id="copy"><i class="fa fa-files-o"></i></button>'
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
	extraFields: ["space"]
	lengthChange: false
	ordering: false
	pageLength: 10
	info: false
	searching: true
	autoWidth: false

if Meteor.isServer
	db.instance_number_rules._ensureIndex({
		"space": 1,
		"name": 1
	},{background: true})