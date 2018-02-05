FlowRouter.route '/', 
	action: (params, queryParams)->
		Meteor.autorun ->
			if !Meteor.userId()
				FlowRouter.go "/steedos/sign-in";
			else
				homeUrl = Steedos.getHomeUrl()
				if homeUrl
					FlowRouter.go homeUrl

Meteor.startup ->
	if Meteor.isClient
		db.apps.INTERNAL_APPS = ["/workflow", "/cms", "/calendar", "/emailjs", "/admin", "/portal", "/contacts", "/dashboard", "/records_search"]
