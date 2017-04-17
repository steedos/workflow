RecordsQHD = {}

#	*    *    *    *    *    *
#	┬    ┬    ┬    ┬    ┬    ┬
#	│    │    │    │    │    |
#	│    │    │    │    │    └ day of week (0 - 7) (0 or 7 is Sun)
#	│    │    │    │    └───── month (1 - 12)
#	│    │    │    └────────── day of month (1 - 31)
#	│    │    └─────────────── hour (0 - 23)
#	│    └──────────────────── minute (0 - 59)
#	└───────────────────────── second (0 - 59, OPTIONAL)

RecordsQHD.recurrenceRule = "13 18 * * *"

schedule = Npm.require('node-schedule')

RecordsQHD.test = () ->
	console.log "[#{new Date()}]run RecordsQHD.test"

RecordsQHD.scheduleJobMaps = {}

RecordsQHD.contractInstanceToArchive = ()->
	records_qhd_sett = Meteor.settings.records_qhd

	spaces = records_qhd_sett.spaces

	archive_server = records_qhd_sett.archive_server

	to_archive_api = records_qhd_sett.contract_instances.to_archive_api

	flows = records_qhd_sett.contract_instances.flows

	field_map = records_qhd_sett.contract_instances.field_map

	instancesToArchive = new InstancesToArchive(spaces, archive_server, to_archive_api, flows)

	instancesToArchive.sendContractInstances(field_map)

RecordsQHD.startScheduleJob = (name, recurrenceRule, fun) ->

	if !recurrenceRule
		console.log "Miss recurrenceRule"
		return
	if !_.isString(recurrenceRule)
		console.log "RecurrenceRule is not String. https://github.com/node-schedule/node-schedule"
		return

	if !fun
		console.error "Miss function"
	else if !_.isFunction(fun)
		console.error "#{fun} is not function"
	else
		RecordsQHD.scheduleJobMaps[name] = schedule.scheduleJob recurrenceRule, fun

RecordsQHD.startScheduleJob "RecordsQHD.contractInstanceToArchive", RecordsQHD.recurrenceRule, Meteor.bindEnvironment(RecordsQHD.contractInstanceToArchive)