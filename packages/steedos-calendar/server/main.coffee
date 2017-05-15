import { Meteor } from 'meteor/meteor';
icalendar = require('icalendar');
@moment_timezone = require('moment-timezone');
Meteor.startup ->
	
@Calendar = 
	#更新日历，新建事件，更新事件，删除事件会触发此函数。operation:1新建，2更新，3删除
	addChange : (calendarId, objectUri, operation)->
		oldsynctoken = Calendars.findOne({_id:calendarId}).synctoken;
		calendarchanges.direct.insert
			uri:objectUri,
			synctoken: oldsynctoken,
			calendarid: calendarId,
			operation: operation
		Calendars.direct.update({_id:calendarId},{$set:{synctoken:oldsynctoken+1}});
	#被分享的成员比创建者多share_herf,share_displayname. 
	#access对应 1 = owner, 2 = readonly, 3 = readwrite
	addInstance : (userId,doc,calendarid,steedosId,access,herf,displayname)->
		if doc.visibility == 'private'
			transp = false;
		else
			transp = true;
		zones=moment_timezone.tz.zone(doc.timezone);
		ical = new icalendar.iCalendar();
		vtimezone=ical.addComponent('VTIMEZONE');
		vtimezone.addProperty("TZID",doc.timezone);
		standard = vtimezone.addComponent("STANDARD");
		standard.addProperty("TZOFFSETFROM","0"+(-zones.offsets[0])/60+"00");
		standard.addProperty("TZOFFSETTO","0"+(-zones.offsets[1])/60+"00");
		standard.addProperty("TZNAME",zones.abbrs[0]);
		timezone = ical.toString();
		calendarinstances.insert
			principaluri:"principals/" + steedosId,
			transparent:transp,
			access:access,
			share_invitestatus:2,
			calendarid: calendarid,
			displayname:doc.title,
			description:"null",
			uri:calendarid,
			calendarorder:3,
			calendarcolor: doc.color,
			timezone :timezone,
			share_herf:herf,
			share_displayname: displayname
	#新建或跟更新事件，事件对应的calendardata
	addEvent :(userId, doc)->
		ical = new icalendar.iCalendar();
		vevent = new icalendar.VEvent(doc._id);
		vtimezone=ical.addComponent('VTIMEZONE');
		ical.addComponent(vevent);
		vtimezone.addProperty("TZID","Asia/Shanghai");
		standard = vtimezone.addComponent("STANDARD");
		standard.addProperty("TZOFFSETFROM","0800");
		standard.addProperty("TZOFFSETTO","0800");
		standard.addProperty("TZNAME","CST");
		date=new Date(2017/5/1);
		standard.addProperty("DTSTART",date);
		# daylight = vtimezone.addComponent("DAYLIGHT");
		# daylight.addProperty("TZOFFSETFROM","0800");
		# daylight.addProperty("TZNAME","GMT+8");
		# daylight.addProperty("TZOFFSETTO","0900");
		if doc.alarms !=undefined
			alarm = vevent.addComponent('VALARM');
			alarm.addProperty("ACTION", 'DISPLAY');
			alarm.addProperty("TRIGGER;VALUE=DURATION", doc.alarms);
			alarm.addProperty("DESCRIPTION","Default Mozilla Description"); 
		vevent.setDescription(doc.description);
		vevent.addProperty("TRANSP","OPAQUE");#得改
		vevent.addProperty("CREATED",new Date());
		vevent.addProperty("LAST-MODIFIED",new Date());
		vevent.setSummary(doc.title);
		vevent.addProperty("ORGANIZER;RSVP=TRUE;PARTSTAT=ACCEPTED;ROLE=CHAIR:mailto",Meteor.users.findOne({_id:userId}).steedos_id);
		vevent.setLocation("Shanghai");   
		for member,i in doc.members 
			member = doc.members[i]
			if member!= userId
				vevent.addProperty("ATTENDEE;RSVP=TRUE;PARTSTAT=NEEDS-ACTION;ROLE=REQ-PARTICIPANT;SCHEDULE-STATUS=3.7", Meteor.users.findOne({_id:member}).steedos_id);
		#vevent.setDate(doc.start,doc.end);
		if doc.allDay==true
			vevent.addProperty("DTSTART;VALUE=DATE",moment(new Date(doc.start+8*3600)).format("YYYYMMDD"));
			vevent.addProperty("DTEND;VALUE=DATE",moment(new Date(doc.end+8*3600)).format("YYYYMMDD"));
		else
			vevent.addProperty("DTSTART;TZID=Asia/Shanghai",moment(new Date(doc.start+8*3600)).format("YYYYMMDDThhmmss"));#TZID得改
			vevent.addProperty("DTEND;TZID=Asia/Shanghai",moment(new Date(doc.end+8*3600)).format("YYYYMMDDThhmmss"));
		vevent.addProperty("SEQUENCE",0);#得改
		calendardata = ical.toString();
		return calendardata
		