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
	if Meteor.settings.remind and Meteor.settings.remind.cron
		schedule = Npm.require('node-schedule')
		# 定时执行同步
		rule = Meteor.settings.remind.cron
		go_next = true
		schedule.scheduleJob rule, Meteor.bindEnvironment ()->
			if !go_next
	        	return
	      	go_next = false
			console.time 'remind'
			now = new Date
			day_time = 1*24*60*60*1000
			hour_time = 1*60*60*1000
			db.instances.find({state: 'pending', 'values.priority': {$exists: true}, 'values.deadline': {$exists: true}}).forEach (ins)->
				console.log ins.name
				priority = ins.values.priority

				last_trace = _.last(ins.traces)
				_.each last_trace.approves, (ap)->
					if ap.is_finished isnt true and ap.deadline and ap.remind_date
						if ap.remind_date < now
							user = db.users.findOne({_id: ap.user}, {fields: {mobile: 1}})
							moment_format = 'MM-DD HH:mm'
							params = {
								instance: ins.name
							}
							reminded_count = ap.reminded_count
							remind_datetime = ap.remind_date.getTime()
							# （1）“普通”：如三个工作日内未处理，系统自动发短信提醒：办结时限为二日内；
							#  如二日后仍未处理，系统每天自动发短信提醒，办结时限为一日内。
							if priority is "普通"
								if reminded_count is 0
									ap.reminded_count = 1
									ap.remind_date = new Date(remind_datetime + 2*day_time)
									params.deadline = "二日内"

								else if reminded_count >= 1
									ap.reminded_count += 1
									ap.remind_date = new Date(remind_datetime + 1*day_time)
									params.deadline = "一日内"
							# （2）“办文”：如一个工作日内未处理，系统自动发短信提醒：办结时限为表单上的“办结时限”（文书录入的时间）；
							#  如一日后仍未处理，系统每天自动发短信提醒：办结时限不变；
							#  距离办结时限为半日时，则每半个工作日提醒四次；超过办结时限后仍然按照每半日四次提醒。
							else if priority is "办文"
								if reminded_count is 0
									ap.reminded_count = 1
									ap.remind_date = new Date(remind_datetime + 1*day_time)
								else if reminded_count >= 1
									ap.reminded_count += 1
									if (now - ap.deadline) > 0  or (now - ap.deadline) < -4*hour_time # 超过了办结时限或者距离办结时限半日内
										ap.remind_date = new Date(remind_datetime + 1*hour_time)
									else
										ap.remind_date = new Date(remind_datetime + 1*day_time)
								params.deadline = moment(ap.deadline).format(moment_format)

							# （3）“紧急”：在发送的同时，系统自动发短信提醒：办结时限为表单上的“办结时限”（文书录入的时间）；
							#  如半日内仍未处理，系统每半天自动发短信提醒：办结时限不变；距离办结时限为半日时，每半个工作日提醒四次；超过办结时限后仍然按照每半日四次提醒。
							else if priority is "紧急"
								ap.reminded_count += 1
								if (now - ap.deadline) > 0  or (now - ap.deadline) < -4*hour_time # 超过了办结时限或者距离办结时限半日内
									ap.remind_date = new Date(remind_datetime + 1*hour_time)
								else
									ap.remind_date = new Date(remind_datetime + 4*hour_time)
								params.deadline = moment(ap.deadline).format(moment_format)

							# （4）“特急”：在发送的同时，系统自动发短信提醒：办结时限为表单上的“办结时限”（文书录入的时间）；
							#  如半日内仍未处理，系统每半个工作日提醒四次：办结时限不变；超过办结时限后仍然按照每半日四次提醒。
							else if priority is "特急"
								ap.reminded_count += 1
								ap.remind_date = new Date(remind_datetime + 1*hour_time)
								params.deadline = moment(ap.deadline).format(moment_format)

							if user and user.mobile
								console.log "===>SMSQueue.send: #{user.mobile}"
								console.log params
								# 发送手机短信
								SMSQueue.send({
									Format: 'JSON',
									Action: 'SingleSendSms',
									ParamString: JSON.stringify(params),
									RecNum: user.mobile,
									SignName: 'OA系统',
									TemplateCode: 'SMS_66340019'
								})
				db.instances.update({_id: ins._id, "traces._id": last_trace._id}, {$set: {'traces.$.approves': last_trace.approves}})

			console.timeEnd 'remind'
			go_next = true
		, ()->
			console.log 'Failed to bind environment'