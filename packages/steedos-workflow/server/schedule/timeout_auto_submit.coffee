###
*    *    *    *    *    *
┬    ┬    ┬    ┬    ┬    ┬
│    │    │    │    │    |
│    │    │    │    │    └ day of week (0 - 7) (0 or 7 is Sun)
│    │    │    │    └───── month (1 - 12)
│    │    │    └────────── day of month (1 - 31)
│    │    └─────────────── hour (0 - 23)
│    └──────────────────── minute (0 - 59)
└───────────────────────── second (0 - 59, OPTIONAL)
###
Meteor.startup ->
	if Meteor.settings.cron?.timeout_auto_submit
		schedule = require('node-schedule')
		# 定时执行同步
		rule = Meteor.settings.cron.timeout_auto_submit
		go_next = true
		schedule.scheduleJob rule, Meteor.bindEnvironment ()->
			try
				if !go_next
					return
				go_next = false
				console.time 'timeout_auto_submit'



				console.timeEnd 'timeout_auto_submit'
				go_next = true

			catch e
				console.error "AUTO TIMEOUT_AUTO_SUBMIT ERROR: "
				console.error e.stack
				go_next = true

		, ()->
			console.log 'Failed to bind environment'

Meteor.methods
	timeout_auto_submit: (ins_id)->
		check ins_id, String
		query = {}
		if ins_id
			query._id = ins_id

		query.state = 'pending'
		query.current_step_auto_submit = true
		query.traces = { $elemMatch: { is_finished: false, due_date: { $lte: new Date } } }

		db.instances.find(query).forEach (ins)->
			try
				flow_id = ins.flow
				instance_id = ins._id
				trace = _.last ins.traces
				flow = uuflowManager.getFlow(flow_id)
				step = uuflowManager.getStep(ins, flow, trace.step)
				step_type = step.step_type
				toLine = _.find step.lines, (l)->
					return l.timeout_line == true
				nextStepId = toLine.to_step
				nextUserIds = getHandlersManager.getHandlers(instance_id, nextStepId)

				judge = "submitted"
				if step_type is "sign"
					judge = "approved"

				approve_from_client = {
					'instance': instance_id
					'trace': trace._id
					'judge': judge
					'next_steps': [{ 'step': nextStepId, 'users': nextUserIds }]
				}
				_.each trace.approves, (a)->
					approve_from_client._id = a._id
					current_user_info = db.users.findOne(a.handler, { services: 0 })
					uuflowManager.workflow_engine(approve_from_client, current_user_info, current_user_info._id)

			catch e
				console.error 'AUTO TIMEOUT_AUTO_SUBMIT ERROR: '
				console.error e.stack


		return 'success'


