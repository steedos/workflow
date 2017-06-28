###
开发（在某些步骤） 发送到下一步、传阅给某些人 的时候, 发送短信通知待处理人
###
JsonRoutes.add 'post', '/api/webhook/notify/cc/steps', (req, res, next) ->
	try
		hashData = req.body
		
		if _.isEmpty(hashData) or _.isEmpty(hashData.instance) or _.isEmpty(hashData.current_approve)
			JsonRoutes.sendResult res,
				code: 500
				data: { errors: "不具备hook执行条件"}

		current_approve = hashData.current_approve
		current_cc_user_ids = current_approve.cc_user_ids

		instance = hashData.instance
		ins_name = instance.name
		name = if ins_name.length > 15 then ins_name.substr(0,12) + '...' else ins_name

		current_trace = _.last(instance.traces)
		ins_id = instance._id
		space_id = instance.space

		trace_name = current_trace.name

		steps_name = ['值班员分发']

		params = {
			instance_name: name
		}

		if steps_name.includes(trace_name) && current_trace._id is current_approve.trace
			_.each current_trace.approves, (ap)->
				if ap.type is 'cc' and ap.is_finished isnt true and current_cc_user_ids.includes(ap.user)
					user = db.users.findOne({_id: ap.user}, {fields: {mobile: 1, locale: 1}})
					if user and user.mobile
						#设置当前语言环境
						lang = 'en'
						if user.locale is 'zh-cn'
							lang = 'zh-CN'
						
						# 发送手机短信
						SMSQueue.send({
								Format: 'JSON',
								Action: 'SingleSendSms',
								ParamString: JSON.stringify(params),
								RecNum: user.mobile,
								SignName: 'OA系统',
								TemplateCode: 'SMS_67200967',
								msg: TAPi18n.__('sms.meeting_cc.template', {instance_name: ins_name, open_app_url: Meteor.absoluteUrl()+"workflow.html?space_id=#{space_id}&ins_id=#{ins_id}"}, lang)
							})

		JsonRoutes.sendResult res,
				code: 200
				data: {}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 500
			data: { errors: [{errorMessage: e.message}] }
	
		