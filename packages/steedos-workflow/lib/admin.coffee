db.forms.adminConfig = 
	icon: "globe"
	color: "blue"
	tableColumns: [
		{name: "name"},
		{name: "is_table_style"},
	]
	selector: {space: -1}
	showDelColumn: false
	showCreColumn: false
	routerAdmin: "/admin/view/forms"

Meteor.startup ->

	@forms = db.forms
	AdminConfig?.collections_add
		forms: db.forms.adminConfig

if Meteor.isClient
    Meteor.startup ->
        Tracker.autorun ->
            if Meteor.userId() and Session.get("spaceId")
                AdminTables["forms"]?.selector = {space: Session.get("spaceId")}