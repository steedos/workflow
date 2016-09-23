db.address_books = new Meteor.Collection('address_books')

db.address_books._simpleSchema = new SimpleSchema
	
	owner: 
		type: String,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Meteor.userId();
	
	name:
		type: String,
	email: 
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

	db.address_books._simpleSchema.i18n("address_books")

db.address_books.attachSchema(db.address_books._simpleSchema)

