@calendarchanges = new Mongo.Collection('calendar_changes');
MD5 = require('MD5');
calendarchanges.attachSchema new SimpleSchema 

	uri:  
		type: String
		optional: true
		autoform: 
			omit: true

	synctoken:   
		type: Number 
		optional: true
		autoform: 
			omit: true
	
	calendarid:  
		type: String
		optional: true
		autoform: 
			omit: true
	operation:
		type :Number
		optional : true
		autoform:
			omit:true

			
if (Meteor.isServer) 
	calendarchanges.allow 
		insert: (userId, doc) ->
			return true

		update: (userId, doc) ->
			return true

		remove: (userId, doc) ->
			return true
calendarchanges.before.insert (userId, doc)->
	doc._id = MD5(doc._id);