@moment_timezone = require('moment-timezone');
@Calendar = {}

# Steedos.API.setAppTitle("Steedos Calendar");

Meteor.startup ->
	$("body").css("background-image", "url('/packages/steedos_theme/client/background/birds.jpg')");

Tracker.autorun ()->
	if Session.get("steedos-locale") == "zh-cn"
		TAPi18n.setLanguage("zh-CN")
	else
		TAPi18n.setLanguage("en")		

Tracker.autorun ()->
	if Meteor.userId()
		Meteor.call('calendarInit',moment_timezone.tz.guess())
