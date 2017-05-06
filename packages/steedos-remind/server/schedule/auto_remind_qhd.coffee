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

		schedule.scheduleJob rule, Meteor.bindEnvironment((->
			console.time 'remind'
			







			console.timeEnd 'remind'
		), ->
			console.log 'Failed to bind environment'
		)