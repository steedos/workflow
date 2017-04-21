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

logger = new Logger 'Records_QHD'

RecordsQHD.recurrenceRule = Meteor.settings.records_qhd.recurrence_rule

schedule = Npm.require('node-schedule')

RecordsQHD.test = () ->
	console.log "[#{new Date()}]run RecordsQHD.test"

RecordsQHD.scheduleJobMaps = {}

RecordsQHD.instanceToArchive = ()->
	records_qhd_sett = Meteor.settings.records_qhd

	spaces = records_qhd_sett.spaces

	archive_server = records_qhd_sett.archive_server

	flows = records_qhd_sett.contract_instances.flows

	instancesToArchive = new InstancesToArchive(spaces, archive_server, flows)

	contract_archive_api = records_qhd_sett.contract_instances.to_archive_api
	instancesToArchive.sendContractInstances(contract_archive_api);

	to_archive_api = records_qhd_sett.non_contract_instances.to_archive_api
	instancesToArchive.sendNonContractInstances(to_archive_api)

RecordsQHD.startScheduleJob = (name, recurrenceRule, fun) ->

	if !recurrenceRule
		logger.error "Miss recurrenceRule"
		return
	if !_.isString(recurrenceRule)
		logger.error "RecurrenceRule is not String. https://github.com/node-schedule/node-schedule"
		return

	if !fun
		logger.error "Miss function"
	else if !_.isFunction(fun)
		logger.error "#{fun} is not function"
	else
		logger.info "Add scheduleJobMaps: #{name}"
		RecordsQHD.scheduleJobMaps[name] = schedule.scheduleJob recurrenceRule, fun

RecordsQHD.startScheduleJob "RecordsQHD.instanceToArchive", RecordsQHD.recurrenceRule, Meteor.bindEnvironment(RecordsQHD.instanceToArchive)