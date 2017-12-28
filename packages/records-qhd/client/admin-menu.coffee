Meteor.startup ()->

	# 同步合同台账
	Steedos.addAdminMenu
		_id: "records_qhd_sync_contracts"
		title: "records_qhd_sync_contracts_title"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-loop"
		url: "/records_qhd/sync_contracts"
		sort: 2000
		roles: ["space_admin"]
		parent: "advanced_setting"

	# 申请单重归档
	Steedos.addAdminMenu
		_id: "records_qhd_sync_archive"
		title: "records_qhd_sync_archive_title"
		mobile: false
		app: "workflow"
		icon: "ion ion-ios-loop"
		url: "/records_qhd/sync_archive"
		sort: 1900
		roles: ["space_admin"]
		parent: "advanced_setting"