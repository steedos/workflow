Meteor.startup ->
	MailQueue.Configure
		sendInterval: 1000
		sendBatchSize: 10
		keepMails: false