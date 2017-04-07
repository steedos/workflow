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
		regEx: /^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/i

	content_type:
		type: String
		autoform:
			type: "select"
			options: ->
				return [{label:"application/json", value:"application/json"}, {label:"application/x-www-form-urlencoded", value: "application/x-www-form-urlencoded"}]

	active:
		type: Boolean
		optional: true
		defaultValue: false
		autoform:
			defaultValue: false

	description:
		type: String
		optional: true
		autoform:
			type: "textarea"
	
if Meteor.isClient
	db.webhooks._simpleSchema.i18n("webhooks")


db.webhooks.attachSchema(db.webhooks._simpleSchema)

db.webhooks.helpers
	flow_name: ()->
		f = db.flows.findOne({_id: this.flow}, {fields: {name: 1}})
		return f && f.name