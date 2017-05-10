Meteor.methods
	instance_remind: (remind_users, remind_count, remind_deadline, instance_id)->
		check remind_users, Array
		check remind_count, Number
		check remind_deadline, Date
		check instance_id, String

		ins = db.instances.findOne({_id: instance_id}, {fields: {name: 1}})
		paramString = JSON.stringify({
			instance: ins.name,
			deadline: moment(remind_deadline).format('MM-DD HH:mm')
		})
		db.users.find({_id: {$in: remind_users}, mobile: {$exists: true}}, {fields: {mobile: 1}}).forEach (user)->
			# 发送手机短信
			SMSQueue.send({
				Format: 'JSON',
				Action: 'SingleSendSms',
				ParamString: paramString,
				RecNum: user.mobile,
				SignName: 'OA系统',
				TemplateCode: 'SMS_66340019'
			})

		return true
