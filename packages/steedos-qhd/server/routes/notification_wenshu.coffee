###
集团收文、集团公司请示报告 发给集团办公室文书（jbws）， 股份收文、股份请示报告 发给股份公司文书(gfgsws)
###
JsonRoutes.add 'post', '/api/webhook/notification/wenshu', (req, res, next) ->
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
		current_trace_id = current_approve.trace
		instance = hashData.instance
		ins_name = instance.name
		ins_id = instance._id
		space_id = instance.space

		current_trace = _.find(instance.traces, (t)->
			return t._id is current_trace_id
		)

		trace_name = current_trace.name

		steps_name = ['领导批示', '集团领导批示', '股份领导批示']

		if steps_name.includes(trace_name)
			if current_approve.description and current_approve.description isnt "已阅" and current_approve.description isnt "已阅。" and current_approve.description isnt "同意" and current_approve.description isnt "同意。"
				flow = db.flows.findOne({_id:instance.flow},{fields: {name: 1}})
				users = []
				if flow.name.indexOf('集团') > -1
					users.push db.users.findOne({"username": "jbws"}, {fields: {name: 1}})
					users.push db.users.findOne({"username": "gfgsws"}, {fields: {name: 1}})
				else if flow.name.indexOf('股份') > -1
					users.push db.users.findOne({"username": "gfgsws"}, {fields: {name: 1}})

				_.each users, (user)->
					notification = new Object
					notification["createdAt"] = new Date
					notification["createdBy"] = '<SERVER>'
					notification["from"] = 'workflow'
					notification['title'] = user.name
					notification['text'] = "#{current_approve.handler_name}在#{ins_name}中的批示意见为：#{current_approve.description}"

					payload = new Object
					payload["space"] = space_id
					payload["instance"] = ins_id
					payload["host"] = Meteor.absoluteUrl().substr(0, Meteor.absoluteUrl().length-1)
					payload["requireInteraction"] = true
					payload["box"] = "monitor"
					notification["payload"] = payload
					notification['query'] = {userId: user._id, appName: 'workflow'}

					Push.send(notification)

		JsonRoutes.sendResult res,
				code: 200
				data: {}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 500
			data: { errors: [{errorMessage: e.message}] }
