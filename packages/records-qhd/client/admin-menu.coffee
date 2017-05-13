Admin.addMenu
	_id: "records_qhd_sync_contracts"
	title: "records_qhd_sync_contracts_title"
	app: "workflow"
	icon: "ion ion-android-sync"
	url: "/records/space/#{Session.get("spaceId")}/sync_contracts"
	sort: 2000
	roles: ["space_admin"]
	parent: "workflow"