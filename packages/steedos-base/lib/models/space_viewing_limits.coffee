db.space_viewing_limits = new Meteor.Collection('space_viewing_limits')

db.space_viewing_limits._simpleSchema = new SimpleSchema
	space: 
		type: String,
		optional: true,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId")
	name:
		type: String
		max: 200

	members:
		type: Object,
		optional: false

	"members.users": 
		type: [String],
		optional: true,
		autoform:
			type: "selectuser"
			multiple: true


	"members.organizations": 
		type: [String],
		optional: true,
		autoform:
			type: "selectorg"
			multiple: true

	limits:
		type: Object,
		optional: true

	"limits.users": 
		type: [String],
		optional: true,
		autoform:
			type: "selectuser"
			multiple: true


	"limits.organizations": 
		type: [String],
		optional: true,
		autoform:
			type: "selectorg"
			multiple: true


if Meteor.isClient
	db.space_viewing_limits._simpleSchema.i18n("space_viewing_limits")

db.space_viewing_limits.attachSchema db.space_viewing_limits._simpleSchema


if Meteor.isServer

	db.space_viewing_limits.before.insert (userId, doc) ->

	db.space_viewing_limits.before.update (userId, doc, fieldNames, modifier, options) ->

