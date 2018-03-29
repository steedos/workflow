###
在“领导意见”节点，设置步骤脚本，如果曹董事长（曹子玉）签署了不为“已阅”的意见，则给文书（王华宁）发送手机短信：包括标题（含链接，点击即可查看文件）、意见。
###
JsonRoutes.add 'post', '/api/webhook/notify/wenshu', (req, res, next) ->
	try
		hashData = req.body

		if hashData.action isnt 'engine_submit'
			JsonRoutes.sendResult res,
					code: 200
					data: {}
			return

		if _.isEmpty(hashData) or _.isEmpty(hashData.instance) or _.isEmpty(hashData.current_approve)
			throw new Meteor.Error('error', '不具备hook执行条件')

		current_approve = hashData.current_approve
		if current_approve.handler_name is "曹子玉"
			if current_approve.description and current_approve.description isnt "已阅" and current_approve.description isnt "已阅。"
				user = db.users.findOne({"emails.address": "wanghuaning@portqhd.com"}, {fields: {mobile: 1, locale: 1}})
				if user and user.mobile
					#设置当前语言环境
					lang = 'en'
					if user.locale is 'zh-cn'
						lang = 'zh-CN'
					ins_name = hashData.instance.name
					ins_description = current_approve.description
					name = if ins_name.length > 15 then ins_name.substr(0,12) + '...' else ins_name
					description = if ins_description.length > 15 then ins_description.substr(0,12) + '...' else ins_description
					params = {
						handler: current_approve.handler_name,
						instance: name,
						description: description
						# insurl: "/workflow/space/#{hashData.instance.space}/view/readonly/#{hashData.instance._id}"
					}

					# 发送手机短信
					SMSQueue.send({
							Format: 'JSON',
							Action: 'SingleSendSms',
							ParamString: JSON.stringify(params),
							RecNum: user.mobile,
							SignName: 'OA系统',
							TemplateCode: 'SMS_61725087',
							msg: TAPi18n.__('sms.notify_wenshu.template', {handler: params.handler, instance: ins_name, description: ins_description}, lang)
						})


		JsonRoutes.sendResult res,
				code: 200
				data: {}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 500
			data: { errors: [{errorMessage: e.message}] }
