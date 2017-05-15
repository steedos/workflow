import moment from 'moment'
import Calendar from '../core'

@moment = moment

Template.calendarContainer.onRendered ->
	Calendar.generateCalendar();

eventsDep = new Tracker.Dependency;
eventsSub = new SubsManager();
eventsRange = null
eventsLoading = false

Calendar.reloadEvents = () ->
	eventsDep.depend()
	$("#calendar").fullCalendar("refetchEvents")


Calendar.getEventsData = ( start, end, timezone, callback )->
	calendars = []
	objs = Calendars.find({})
	objs.forEach (obj) ->
		calendars.push(obj._id)

	params = 
		start: start.toDate()
		end: end.toDate()
		timezone: timezone
		calendar:calendars
	# console.log JSON.stringify(params)
	eventsLoading = true
	eventsSub.subscribe "calendar_objects", params

	Tracker.autorun (c)->
		if eventsSub.ready()
			events = Events.find().fetch()
			# console.log events
			callback(events)
			c.stop()

Calendar.generateCalendar = ()->
	# console.log $('#calendar').children().length
	if !$('#calendar').children().length
		# console.log event
		$('#calendar').fullCalendar
			height: ()->
				return $('#calendar').height()
			handleWindowResize: true
			header: 
				left: 'month,agendaWeek,agendaDay,listMonth',
				center: 'prev title next',
				right: ''
			selectable: true,
			selectHelper: true,
			navLinks: true
			editable: true
			eventLimit: true
			events: Calendar.getEventsData
			# timezone: "local"
			# locale: Session.get("steedos-locale")
			eventDataTransform: (event) ->
				# console.log event
				copy = 
					id: event._id
					allDay: event.allDay
					title: event.title
					url:event.url
				if event.start
					copy.start = moment.utc(event.start)
					# copy.start =  '2017-04-26'
				if event.end
					copy.start = moment.utc(event.end)
				return copy;
			select: ( start, end, jsEvent, view, resource )->
				console.log ('start'+new Date(start)+'   end'+end)
				Session.set 'cmDoc', 
				 	start: start.toDate()
				 	end: end.toDate()
				$('.btn.event-add').click(); 
			eventClick: (calEvent, jsEvent, view)->
				event = Events.findOne
					_id: calEvent.id
				if event
					Session.set 'cmDoc', event
					$('.btn.event-edit').click();
					console.log ('start'+event.start+'   end'+event.end)


		Events.find().observe
			added: (id, fields) ->
				eventsDep.changed();
			changed: () ->
				eventsDep.changed();
			removed: () ->
				eventsDep.changed();

		Tracker.autorun ()->
			Calendar.reloadEvents();

	else
		Calendar.reloadEvents();
