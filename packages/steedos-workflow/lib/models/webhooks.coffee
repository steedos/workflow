db.webhooks = new Meteor.Collection('webhooks')

db.webhooks._simpleSchema = new SimpleSchema
	space:
		type: String
		optional: true
		autoform:
			type: "hidden"
			defaultValue: ->
				return Session.get("spaceId")

	flow:
		type: String,
		autoform:
			type: "select",
			options: ->
				options = []
				selector = {}
				selector.space = Session.get('spaceId')
				objs = db.flows.find(selector, {fields: {name:1} })
				objs.forEach (obj) ->
					options.push
						label: obj.name,
						value: obj._id
				return options

	payload_url:
		type: String
		regEx: SimpleSchema.RegEx.Url

	content_type:
		type: String
		autoform:
			type: "select"
			options: ->
				return [{label:"application/json", value:"application/json"}, {label:"application/x-www-form-urlencoded", value: "application/x-www-form-urlencoded"}]

	active:
		type: Boolean
		optional: true
		defaultValue: 100
		autoform:
			defaultValue: 100
	
if Meteor.isClient
	db.webhooks._simpleSchema.i18n("webhooks")


db.webhooks.attachSchema(db.webhooks._simpleSchema);