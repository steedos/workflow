db.address_books = new Meteor.Collection('address_books')



db.address_books._simpleSchema = new SimpleSchema

	owner:
		type: String,
		autoform:
			type: "hidden",
			defaultValue: ->
				return Meteor.userId();
	group:
		type: String,
		autoform:
			type: "select",
			options: ()->
				groups = db.address_groups.find().fetch();
				op = new Array();
				groups.forEach (g)->
					op.push({label: g.name, value: g._id})

				return op;
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
