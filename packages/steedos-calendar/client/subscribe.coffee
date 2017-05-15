calendarsSub = new SubsManager();

Meteor.startup ->
	calendarsSub.subscribe "calendars"

	# Tracker.autorun ->
	# 	calendarsSub.subscribe "calendars_members", Session.get("calendarId")
