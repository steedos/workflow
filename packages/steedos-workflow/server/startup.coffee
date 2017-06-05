Meteor.startup ->
	if Meteor.settings.cron?.mailqueue_interval
		MailQueue.Configure
			sendInterval: Meteor.settings.cron.mailqueue_interval
			sendBatchSize: 10
			keepMails: false

	if Meteor.settings.sms?.aliyun?.smsqueue_interval
		SMSQueue.Configure
			sendInterval: Meteor.settings.sms.aliyun.smsqueue_interval
			sendBatchSize: 10
			keepSMS: true
			accessKeyId: Meteor.settings.sms.aliyun.accessKeyId
			accessKeySecret: Meteor.settings.sms.aliyun.accessKeySecret

	if Meteor.settings.cron?.webhookqueue_interval
		WebhookQueue.Configure
			sendInterval: Meteor.settings.cron.webhookqueue_interval
			sendBatchSize: 10
			keepWebhooks: false