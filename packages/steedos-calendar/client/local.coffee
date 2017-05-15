import 'moment/min/moment.min.js'
Tracker.autorun ()->
	console.log ('locale1:'+Session.get("steedos-locale"))
	if Session.get("steedos-locale") == "zh-cn"
		if $('#calendar').children().length
			$('#calendar').fullCalendar('option', 'locale', 'zh-cn')
			console.log ('locale2:'+Session.get("steedos-locale"))
		else
			$('#calendar').fullCalendar('option', 'locale', 'en')