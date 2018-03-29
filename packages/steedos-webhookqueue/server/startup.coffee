Meteor.startup ->
	if Meteor.settings.cron?.webhookqueue_interval
		WebhookQueue.Configure
			sendInterval: Meteor.settings.cron.webhookqueue_interval
			sendBatchSize: 10
			keepWebhooks: false
