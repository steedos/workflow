db.instances = new Meteor.Collection('instances')

db.instances._simpleSchema = new SimpleSchema({
	related_instances: {
		type: [String],
		optional: true,
		autoform: {
			type: "universe-select",
			afFieldInput: {
				multiple: true,
				optionsMethod: "getRelatedInstancesOptions"
			}
		}
	}
})

#db.instances.attachSchema db.instances._simpleSchema

db.instances.helpers
	applicant_name: ->
		applicant = db.space_users.findOne({user: this.applicant});
		if applicant
			return applicant.name;
		else
			return ""

if Meteor.isServer
	db.instances.allow

		insert: (userId, event) ->
			return false

		update: (userId, event) ->
			if event.state == "draft" && (event.applicant == userId || event.submitter == userId)
				return true
			else
				return false

		remove: (userId, event) ->
			return false

	Meteor.methods
		getRelatedInstancesOptions: (options)->
			uid = this.userId;
			searchText = options.searchText;
			values = options.values;
			instanceId = options.params

			selectedOPtions = []

#			Meteor.wrapAsync((callback) ->
#				Meteor.setTimeout (->
#					callback()
#					return
#				), 1000
#				return
#			)()

			options = new Array();

			instances = new Array();

			if instanceId
				instance = db.instances.findOne({_id: instanceId})
				if instance
					selectedOPtions = instance.related_instances

			if searchText
				pinyin = /^[a-zA-Z\']*$/.test(searchText)
				if (pinyin && searchText.length > 8) || (!pinyin && searchText.length > 1)
					console.log "searchText is #{searchText}"
					query = {state: {$in: ["pending", "completed"]}, name: {$regex: searchText},$or: [{submitter: uid}, {applicant: uid}, {inbox_users: uid}, {outbox_users: uid}, {cc_users: uid}]}

					if selectedOPtions && _.isArray(selectedOPtions)
						query._id = {$nin: selectedOPtions}

					instances = db.instances.find(query, {limit: 10, fields: {name: 1, flow: 1, applicant_name: 1}}).fetch()

			else if values.length
				instances = db.instances.find({_id: {$in: values}}, {fields: {name: 1, flow: 1, applicant_name: 1}}).fetch();


			instances.forEach (instance)->
				flow = db.flows.findOne({_id: instance.flow}, {fields: {name: 1}});
				options.push({label: "[" + flow?.name + "]" + instance.name + ", "+ instance.applicant_name, value: instance._id});

			return options;