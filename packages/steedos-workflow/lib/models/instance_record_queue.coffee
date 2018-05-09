Meteor.startup ()->
	console.log("workflow.instance_record_queue")
	if !db.instance_record_queue
		db.instance_record_queue = new Meteor.Collection('instance_record_queue')