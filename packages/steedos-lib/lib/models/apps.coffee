db.apps = new Meteor.Collection('apps')

db.apps._simpleSchema = new SimpleSchema
	space: 
		type: String,
		optional: ()->
			if Meteor.user()?.is_cloudadmin
				return true
			return false
		autoform: 
			type: "select",
			options: ->
				options = []
				selector = {_id: Session.get("spaceId")}

				objs = db.spaces.find(selector, {name:1, sort: {name:1}})
				objs.forEach (obj) ->
					options.push
						label: obj.name,
						value: obj._id
				return options
	name:
		type: String
		max: 200
	url:
		type: String
		max: 200
	auth_name:
		type: String
		optional: true
		max: 200
	on_click: 
		type: String
		optional: true
		autoform: 
			rows: 10
	is_use_ie: 
		type: Boolean
		optional: true
		autoform: 
			defaultValue: false
	icon:
		type: String
		max: 200
		autoform:
			defaultValue: "ion-ios-keypad-outline"
		optional: true
	space_sort:
		type: Number
		optional: true
	secret:
		type: String
		max: 200
		optional: true
	internal:
		type: Boolean
		optional: true
	mobile:
		type: Boolean
		optional: true
	sort:
		type: Number
		optional: true
		defaultValue: 9000
		autoform: 
			omit: true

if Meteor.isClient
	db.apps._simpleSchema.i18n("apps")

db.apps.attachSchema db.apps._simpleSchema;
