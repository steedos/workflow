Meteor.publish "calendar_objects", (params)->
	selector =
		calendarid:{$in: params.calendar},
		start:{ $exists: true },
		$or:[
			start: {$lt: params.end},
			end: {$gt: params.start}
		]
	return Events.find(selector)