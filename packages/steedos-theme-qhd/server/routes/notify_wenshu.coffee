###
在“领导意见”节点，设置步骤脚本，如果曹董事长（曹子玉）签署了不为“已阅”的意见，则给文书（王华宁）发送手机短信：包括标题（含链接，点击即可查看文件）、意见。
###
JsonRoutes.add 'post', '/api/webhook/notify/wenshu', (req, res, next) ->
	try
		hashData = req.body
		
		if _.isEmpty(hashData) or _.isEmpty(hashData.instance) or _.isEmpty(hashData.current_approve)
			JsonRoutes.sendResult res,
				code: 500
				data: { errors: "不具备hook执行条件"}

		current_approve = hashData.current_approve
		if current_approve.handler_name is "曹子玉"
			if current_approve.description and current_approve.description isnt "已阅"
				user = db.users.findOne({"emails.address": "wanghuaning@portqhd.com"})
				if user and user.mobile
					params = {
						handler: current_approve.handler_name,
						instance: hashData.instance.name,
						description: current_approve.description,
						# insurl: "/workflow/space/#{hashData.instance.space}/view/readonly/#{hashData.instance._id}"
						insurl: "workflow/"
					}
					# 发送手机短信
					SMSQueue.send({
							Format: 'JSON',
							Action: 'SingleSendSms',
							ParamString: JSON.stringify(params),
							RecNum: user.mobile,
							SignName: 'OA系统',
							TemplateCode: 'SMS_60335446'
						})
					

		JsonRoutes.sendResult res,
				code: 200
				data: {}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 500
			data: { errors: [{errorMessage: e.message}] }
	
		