db.flows = new Meteor.Collection('flows')

if Meteor.isServer
	db.flows.before.insert (userId, doc) ->
		doc.created_by = userId;
		doc.created = new Date();
		if doc.current
			doc.current.created_by = userId;
			doc.current.created = new Date();
			doc.current.modified_by = userId;
			doc.current.modified = new Date();


db.flows._simpleSchema = new SimpleSchema
	space: 
		type: String,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");
	name: 
		type: String
		autoform:
			readonly: true

	print_template:
		type: String,
		optional: true
		autoform:
			rows: 10,

	instance_template:
		type: String,
		optional: true
		autoform:
			rows: 10,

	name_formula:
		type: String
		optional: true
		autoform:
			omit: true

	code_formula:
		type: String
		optional: true
		autoform:
			omit: true

	description:
		type: String
		optional: true
		autoform:
			omit: true

	is_valid:
		type: Boolean
		optional: true
		autoform:
			omit: true

	form:
		type: String
		optional: true
		autoform:
			omit: true

	flowtype:
		type: String
		optional: true
		autoform:
			omit: true

	state:
		type: String
		optional: true
		defaultValue: "disabled"
		autoform:
			omit: true

	is_deleted:
		type: Boolean
		optional: true
		autoform:
			omit: true

	created:
		type: Date
		optional: true
		autoform:
			omit: true

	created_by:
		type: String
		optional: true
		autoform:
			omit: true

	help_text:
		type: String
		optional: true
		autoform:
			omit: true

	current_no:
		type: Number
		optional: true
		autoform:
			omit: true

	current:
		type: Object
		optional: true
		blackbox: true
		autoform:
			omit: true

	historys:
		type: [Object]
		optional: true
		blackbox: true
		autoform:
			omit: true

	perms:
		type: Object
		optional: true
		blackbox: true
		autoform:
			omit: true

	error_message:
		type: Object
		optional: true
		blackbox: true
		autoform:
			omit: true

	app:
		type: String
		optional: true
		autoform:
			omit: true

	events:
		type: String
		optional: true
		autoform: 
			rows: 10


if Meteor.isClient
	db.flows._simpleSchema.i18n("flows")

db.flows.attachSchema(db.flows._simpleSchema)

if Meteor.isServer

	db.flows.allow
		insert: (userId, event) ->
			return false

		update: (userId, event) ->
			if (!Steedos.isSpaceAdmin(event.space, userId))
				return false
			else
				return true

		remove: (userId, event) ->
			return false
	
	db.flows.before.insert (userId, doc) ->
		doc.created_by = userId;
		doc.created = new Date();

		if (!Steedos.isSpaceAdmin(doc.space, userId))
			throw new Meteor.Error(400, "error_space_admins_only");

	db.flows.before.update (userId, doc, fieldNames, modifier, options) ->

		modifier.$set = modifier.$set || {};

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();

		if (!Steedos.isSpaceAdmin(doc.space, userId))
			throw new Meteor.Error(400, "error_space_admins_only");

	db.flows.before.remove (userId, doc) ->

		if (!Steedos.isSpaceAdmin(doc.space, userId))
			throw new Meteor.Error(400, "error_space_admins_only");

new Tabular.Table
	name: "Flows",
	collection: db.flows,
	columns: [
		{data: "name", title: "name"},
#		{data: "state", title: "state"},
		{
			data: "",
			title: "",
			orderable: false,
			width: '1px',
			render: (val, type, doc) ->
				return '<button type="button" class="btn btn-xs btn-default" id="editFlow"><i class="fa fa-pencil"></i></button>'
		},{
			data: "",
			title: "",
			orderable: false,
			width: '1px',
			render: (val, type, doc) ->
				return '<a target="_blank" class="btn btn-xs btn-default" id="exportFlow"href="/api/workflow/export/form?form=' + doc.form + '"><i class="fa fa-download"></i></a>'
		},
	]
	extraFields: ["form","print_template","instance_template","events"]