checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		Steedos.redirectToSignIn()

dashboardRoutes = FlowRouter.group
	triggersEnter: [ checkUserSigned ],
	prefix: '/dashboard',
	name: 'dashboardRoutes'

dashboardRoutes.route '/',
	action: (params, queryParams)->
		Tracker.autorun (c)->
			if Steedos.subsBootstrap.ready("my_spaces") and Steedos.subsBootstrap.ready("portal_dashboards")
				spaceId = Steedos.spaceId()
				if spaceId
					dashboard = db.portal_dashboards.findOne({space:spaceId},{sort:{created:1}})
					defaultId = Meteor.settings?.public?.dashboard?.default
					dashboardId = if dashboard then dashboard._id else defaultId
					unless /^\/dashboard/.test(FlowRouter.current().path)
						c.stop()
						return
					if dashboardId
						FlowRouter.go "/dashboard/space/#{spaceId}/#{dashboardId}"
					else
						FlowRouter.go "/dashboard/space/#{spaceId}"

dashboardRoutes.route '/space/:spaceId/:dashboardId', 
	action: (params, queryParams)->
		Steedos.setSpaceId(params.spaceId)
		Session.set("dashboardId", params.dashboardId)
		BlazeLayout.render 'dashboardLayout',
			main: "dashboardView"

dashboardRoutes.route '/space/:spaceId',
	action: (params, queryParams)->
		Session.set("dashboardId", null)
		BlazeLayout.render 'dashboardLayout',
			main: "dashboardView"