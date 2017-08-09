checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in';

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
					if dashboard
						c.stop()
						dashboardId = dashboard._id
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

		BlazeLayout.render 'dashboardLayout',
			main: "dashboardView"