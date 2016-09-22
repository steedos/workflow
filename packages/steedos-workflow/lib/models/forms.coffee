db.forms = new Meteor.Collection('forms')


db.forms._simpleSchema = new SimpleSchema
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

	is_table_style: 
		type: Boolean
		optional: true


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

if Meteor.isServer
    db.forms.before.insert (userId, doc) ->
        doc.created_by = userId;
        doc.created = new Date();
        if doc.current
            doc.current.created_by = userId;
            doc.current.created = new Date();
            doc.current.modified_by = userId;
            doc.current.modified = new Date();


db.forms.attachSchema(db.forms._simpleSchema)