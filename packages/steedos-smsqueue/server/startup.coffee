Meteor.startup ->
	if Meteor.settings.sms?.aliyun?.smsqueue_interval
		SMSQueue.Configure
			sendInterval: Meteor.settings.sms.aliyun.smsqueue_interval
			sendBatchSize: 10
			keepSMS: true
			accessKeyId: Meteor.settings.sms.aliyun.accessKeyId
			accessKeySecret: Meteor.settings.sms.aliyun.accessKeySecret
