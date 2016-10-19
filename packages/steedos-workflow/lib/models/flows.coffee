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

	instance_style: 
		type: String
		optional: true
		autoform:
			options:[{label: '默认', value:'default'}, {label: '表格', value:'table'}]
			defaultValue: 'default'


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


if Meteor.isClient
	db.flows._simpleSchema.i18n("flows")

db.flows.attachSchema(db.flows._simpleSchema)