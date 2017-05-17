Meteor.publish "calendars", (params)->
	
	unless this.userId
		return this.ready();

	console.log Calendars.find({"ownerId":this.userId}).count()
	if Calendars.find({"ownerId":this.userId}).count()==0
		name=Meteor.users.findOne({_id:this.userId}).name
		Calendars.insert
			title:name+"的日历",
			members:[this.userId],
			visibility:"private",
			color:"#c74444",
			ownerId:this.userId,
			timezone:"Asia/Shanghai",
			components:["VEVENT","VTODO"],
			synctoken:1
	return Calendars.find({$or:[{"ownerId":this.userId},{"members":this.userId}]});
