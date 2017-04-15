RecordsQHD = {}

RecordsQHD.contractInstanceToArchive = ()->
	records_qhd_sett = Meteor.settings.records_qhd

	spaces = records_qhd_sett.spaces

	archive_server = records_qhd_sett.archive_server

	to_archive_api = records_qhd_sett.contract_instances.to_archive_api

	flows = records_qhd_sett.contract_instances.flows

	field_map = records_qhd_sett.contract_instances.field_map

	instancesToArchive = new InstancesToArchive(spaces, archive_server, to_archive_api, flows)

	instancesToArchive.sendContractInstances(field_map)
