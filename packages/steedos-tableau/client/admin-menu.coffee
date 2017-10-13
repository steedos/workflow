Meteor.startup ()->
	Admin.addMenu
		_id: "steedos_tableau"
		title: t("steedos_tableau")
		icon: "ion ion-ios-pie-outline"
		mobile: false
		sort: 2500
		roles: []
		url: "/tableau/info"
#		parent: "tableau"

#	Admin.addMenu
#		_id: "steedos_tableau_workflow"
#		title: t("steedos_tableau_workflow")
#		icon: "ion ion-ios-paper-outline"
#		url: "/tableau/workflow"
#		sort: 2500
#		roles: ["space_admin"]
#		parent: "steedos_tableau"