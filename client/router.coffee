FlowRouter.route '/', 
	action: (params, queryParams)->
		if !Meteor.userId()
			FlowRouter.go "/steedos/sign-in";
		else
			homeUrl = Steedos.getHomeUrl()
			FlowRouter.go homeUrl

Meteor.startup ->
	if Meteor.isClient
		db.apps.INTERNAL_APPS = ["/workflow", "/cms", "/calendar", "/emailjs", "/admin", "/portal", "/contacts", "/dashboard", "/records_search"]
