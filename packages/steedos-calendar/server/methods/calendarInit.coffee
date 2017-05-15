Meteor.methods
	calendarInit: (timezone) ->
		if Calendars.find({"ownerId":this.userId}).count()==0
			name=Meteor.users.findOne({_id:this.userId}).name
			Calendars.insert
				title:name+"的日历",
				members:[this.userId],
				visibility:"private",
				color:"#c74444",
				ownerId:this.userId,
				timezone:timezone,
				components:["VEVENT","VTODO"],
				synctoken:1
