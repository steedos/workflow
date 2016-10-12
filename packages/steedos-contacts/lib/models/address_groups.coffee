db.address_groups = new Meteor.Collection('address_groups')

db.address_groups._simpleSchema = new SimpleSchema

	owner: 
		type: String,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Meteor.userId();
	name:
		type: String,

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

	db.address_groups._simpleSchema.i18n("address_groups")

db.address_groups.attachSchema(db.address_groups._simpleSchema)





