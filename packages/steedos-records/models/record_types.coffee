#import Tabular from 'meteor/aldeed:tabular';
@RecordTypes = new Mongo.Collection("record_types");

RecordTypes._simpleSchema = new SimpleSchema 
	title:  
		type: String
	description:  
		type: String

RecordTypes.attachSchema RecordTypes._simpleSchema

if Meteor.isClient
	RecordTypes._simpleSchema.i18n("record_types")

if (Meteor.isServer) 
	RecordTypes.allow 
		insert: (userId, event) ->
			return true

		update: (userId, event) ->
			return true

		remove: (userId, event) ->
			return true


new Tabular.Table
	name: "RecordTypes",
	collection: RecordTypes,
	columns: [
		{data: "title", title: "Title"}
	]
	extraFields: ["description"]
