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
		schedule = require('node-schedule')
		# 定时执行同步
		rule = Meteor.settings.remind.cron
		go_next = true
		schedule.scheduleJob rule, Meteor.bindEnvironment ()->
			try
				# 节假日不执行
				if Steedos.isHoliday(new Date)
					return

				if !go_next
					return
				go_next = false
				console.time 'remind'
				now = new Date
				skip_users = Meteor.settings.remind?.skip_users || []
				# 企业版工作区开放自动催办
				paid_space_ids = _.pluck(db.spaces.find({is_paid: true, modules: "workflow.enterprise"}, {fields: {_id: 1}}).fetch(), "_id")
				db.instances.find({space: {$in: paid_space_ids}, state: 'pending', auto_remind: true}, {fields: {name: 1, values:1, traces: 1, space: 1}}).fetch().forEach (ins)->
					priority = ins.values.priority
					remind_users = new Array
					_.each ins.traces, (t)->
						setObj = new Object
						_.each t.approves, (ap, idx)->
							if ap.is_finished isnt true and ap.remind_date
								if ap.remind_date < now
									user = db.users.findOne({_id: ap.user}, {fields: {mobile: 1, utcOffset: 1, locale: 1, name: 1}})
									utcOffset = if user.hasOwnProperty('utcOffset') then user.utcOffset else 8
									moment_format = 'MM-DD HH:mm'
									ins_name = ins.name
									name = if ins_name.length > 15 then ins_name.substr(0,12) + '...' else ins_name
									params = {
										instance_name: name
									}
									reminded_count = ap.reminded_count
									remind_date = ap.remind_date
									deadline = ap.deadline
									if ap.manual_deadline
										deadline = ap.manual_deadline
									ap_reminded_count = "traces.$.approves." + idx + ".reminded_count"
									ap_remind_date = "traces.$.approves." + idx + ".remind_date"
									# （1）“普通”：如三个工作日内未处理，系统自动发短信提醒：办结时限为二日内；
									#  如二日后仍未处理，系统每天自动发短信提醒，办结时限为一日内。
									if priority is "普通" or not priority
										if reminded_count is 0
											setObj[ap_reminded_count] = 1
											setObj[ap_remind_date] = Steedos.caculateWorkingTime(remind_date, 2)
											params.deadline = "二日内"

										else if reminded_count >= 1
											setObj[ap_reminded_count] = ap.reminded_count + 1
											setObj[ap_remind_date] = Steedos.caculateWorkingTime(remind_date, 1)
											params.deadline = "一日内"
									# （2）“办文”：如一个工作日内未处理，系统自动发短信提醒：办结时限为表单上的“办结时限”（文书录入的时间）；
									#  如一日后仍未处理，系统每天自动发短信提醒：办结时限不变；
									#  距离办结时限为半日时，则每半个工作日提醒四次；超过办结时限后仍然按照每半日四次提醒。
									else if priority is "办文"
										setObj[ap_reminded_count] = reminded_count + 1
										if Steedos.caculatePlusHalfWorkingDay(now) > deadline # 超过了办结时限或者距离办结时限半日内
											setObj[ap_remind_date] = Steedos.caculatePlusHalfWorkingDay(remind_date, true)
										else if Steedos.caculateWorkingTime(now, 1) > deadline
											caculate_date = (base_date)->
												plus_halfday_date = Steedos.caculatePlusHalfWorkingDay(base_date)
												if plus_halfday_date > deadline
													# ap.remind_date = base_date
													setObj[ap_remind_date] = base_date
												else
													caculate_date(Steedos.caculatePlusHalfWorkingDay(base_date, true))
												return
											caculate_date(now)
										else
											setObj[ap_remind_date] = Steedos.caculateWorkingTime(remind_date, 1)
										params.deadline = moment(deadline).utcOffset(utcOffset).format(moment_format)

									# （3）“紧急”：在发送的同时，系统自动发短信提醒：办结时限为表单上的“办结时限”（文书录入的时间）；
									#  如半日内仍未处理，系统每半天自动发短信提醒：办结时限不变；距离办结时限为半日时，每半个工作日提醒四次；超过办结时限后仍然按照每半日四次提醒。
									else if priority is "紧急"
										setObj[ap_reminded_count] = reminded_count + 1
										if Steedos.caculatePlusHalfWorkingDay(now) > deadline # 超过了办结时限或者距离办结时限半日内
											setObj[ap_remind_date] = Steedos.caculatePlusHalfWorkingDay(remind_date, true)
										else
											setObj[ap_remind_date] = Steedos.caculatePlusHalfWorkingDay(remind_date)
										params.deadline = moment(deadline).utcOffset(utcOffset).format(moment_format)

									# （4）“特急”：在发送的同时，系统自动发短信提醒：办结时限为表单上的“办结时限”（文书录入的时间）；
									#  如半日内仍未处理，系统每半个工作日提醒四次：办结时限不变；超过办结时限后仍然按照每半日四次提醒。
									else if priority is "特急"
										setObj[ap_reminded_count] = reminded_count + 1
										setObj[ap_remind_date] =Steedos.caculatePlusHalfWorkingDay(remind_date, true)
										params.deadline = moment(deadline).utcOffset(utcOffset).format(moment_format)

									if user and user.mobile and (not remind_users.includes(user._id)) and (not skip_users.includes(user._id)) # 防止重复发送
										remind_users.push(user._id)
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
											msg: TAPi18n.__('sms.remind.template', {instance_name: ins_name, deadline: params.deadline || "", open_app_url: Meteor.absoluteUrl()+"workflow.html?space_id=#{ins.space}&ins_id=#{ins._id}"}, lang)
										})

										# 发推送消息
										notification = new Object
										notification["createdAt"] = new Date
										notification["createdBy"] = '<SERVER>'
										notification["from"] = 'workflow'
										notification['title'] = user.name
										notification['text'] = TAPi18n.__('instance.push.body.remind', {instance_name: ins_name, deadline: params.deadline || ""}, lang)

										payload = new Object
										payload["space"] = ins.space
										payload["instance"] = ins._id
										payload["host"] = Meteor.absoluteUrl().substr(0, Meteor.absoluteUrl().length-1)
										payload["requireInteraction"] = true
										notification["payload"] = payload
										notification['query'] = {userId: user._id, appName: 'workflow'}

										Push.send(notification)

						if not _.isEmpty(setObj)
							db.instances.update({_id: ins._id, 'traces._id': t._id}, {$set: setObj})

				console.timeEnd 'remind'
				go_next = true

			catch e
				console.error "AUTO REMIND ERROR: "
				console.error e.stack
				go_next = true

		, ()->
			console.log 'Failed to bind environment'
