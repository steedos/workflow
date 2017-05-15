@Events = new Mongo.Collection('calendar_objects');
uuid = require('uuid');
MD5 = require('MD5');
icalendar = require('icalendar');
created = new Date();
Events.attachSchema new SimpleSchema 
	title:  
		type: String

	members:  
		type: [String],
		autoform: 
			type: "universe-select"
			afFieldInput:
				multiple: true
				optionsMethod: "selectGetUsers"

	start:  
		type: Date
		autoform: 
			type: "bootstrap-datetimepicker"

	end:  
		type: Date,
		optional: true
		autoform: 
			type: "bootstrap-datetimepicker"

	allDay: 
		type: Boolean,
		defaultValue: true,
		optional: true

	calendarid:
		type: String,
		autoform:
			type: "select"
			options: ()->
				options = []
				objs = Calendars.find({})
				objs.forEach (obj) ->
					options.push
						label: t(obj.title),
						value: obj._id
				# options[1].select='select'
				return options
				
	description:  
		type: String,
		optional: true,
		autoform:
			rows:2

	ownerId:  
		type: String,
		optional: true
		autoform: 
			omit: true

	alarms:
		type: [String],
		optional: true
		autoform: 
			type: "select-multiple"
			options: [
				{label: "事件发生时", value: "-PT0S"},
				{label: "5 分钟前", value: "-PT5M"},
				{label: "10 分钟前", value: "-PT10M"},
				{label: "15 分钟前", value: "-PT15M"},
				{label: "30 分钟前", value: "-PT30M"},
				{label: "1 小时前", value: "-PT1H"},
				{label: "2 小时前", value: "-PT2H"},
				{label: "1 天前", value: "-P1D"},
				{label: "2 天前", value: "-P2D"}
			]
	componenttype:
		type: String,
		optional: true
		autoform: 
			omit: true

	etag:
		type: String,
		optional: true
		autoform: 
			omit: true

	firstoccurence:
		type: Number,
		optional: true
		autoform: 
			omit: true

	lastmodified:
		type: Number,
		optional: true
		autoform: 
			omit: true

	lastoccurence:
		type: Number,
		optional: true
		autoform: 
			omit: true

	size:
		type: Number,
		optional: true
		autoform: 
			omit: true

	uid:
		type: String,
		optional: true
		autoform: 
			omit: true

	uri:
		type: String,
		optional: true
		autoform: 
			omit: true

	calendardata:
		type: String,
		optional: true
		autoform: 
			omit: true


if (Meteor.isServer) 
	Events.allow 
		insert: (userId, doc) ->
			return true

		update: (userId, doc) ->
			return true

		remove: (userId, doc) ->
			return true
	#创建事件之前，为其添加一些属性
	Events.before.insert (userId, doc)->
		doc.componenttype = "VEVENT"
		doc._id = uuid();
		doc.uid = doc._id	
		doc.uri = doc._id + ".ics"
		myDate = new Date();
		doc.lastmodified = parseInt(myDate.getTime()/1000);
		myDate = new Date(doc.start)
		doc.firstoccurence = parseInt(myDate.getTime()/1000);
		myDate = new Date (doc.end)
		doc.lastoccurence = parseInt(myDate.getTime()/1000);
		doc.calendardata = Calendar.addEvent(userId,doc);
		doc.etag = MD5(doc.calendardata);
		doc.size = doc.calendardata.length;
		
		return
	
	Events.after.insert (userId, doc)->
		starttoken = Calendars.findOne({_id:doc.calendarid}).synctoken;
		Calendar.addChange(doc.calendarid,doc.uri,1);
		return

	Events.before.update (userId, doc, fieldNames, modifier, options) ->
		modifier.$set = modifier.$set || {};
		return
		 
	Events.after.update (userId, doc, fieldNames, modifier, options) ->
		myDate = new Date();
		lastmodified = parseInt(myDate.getTime()/1000);
		myDate = new Date(doc.start)
		firstoccurence = parseInt(myDate.getTime()/1000);
		myDate = new Date (doc.end)
		lastoccurence = parseInt(myDate.getTime()/1000);
		newcalendardata =Calendar.addEvent(userId,doc);
		etag = MD5(newcalendardata);
		size = newcalendardata.length;
		uid = doc._id;
		Events.direct.update {_id:doc._id}, $set:
			lastmodified: lastmodified,
			firstoccurence:firstoccurence,
			lastoccurence: lastoccurence,
			etag: MD5(newcalendardata),
			size: size,
			calendardata: newcalendardata

		starttoken = Calendars.findOne({_id:doc.calendarid}).synctoken;
		Calendar.addChange(doc.calendarid,doc.uri,2)
		return
	
	
	#删除后的操作，同时删除关联的event事件  after delete
	Events.before.remove (userId, doc)->
		return

	Events.after.remove (userId, doc)->
		starttoken = Calendars.findOne({_id:doc.calendarid}).synctoken;
		Calendar.addChange(doc.calendarid,doc.uri,3)
		return
