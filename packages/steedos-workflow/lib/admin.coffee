db.flows.adminConfig = 
	icon: "globe"
	color: "blue"
	tableColumns: [
		{name: "name"},
		{name: "instance_style"},
	]
	selector: {space: -1}
	showDelColumn: false
	routerAdmin: "/app/admin"

Meteor.startup ->

	@flows_template = db.flows
	AdminConfig?.collections_add
		flows_template: db.flows.adminConfig

if Meteor.isClient
    Meteor.startup ->
        Tracker.autorun ->
            if Meteor.userId() and Session.get("spaceId")
                AdminTables["flows_template"]?.selector = {space: Session.get("spaceId")}