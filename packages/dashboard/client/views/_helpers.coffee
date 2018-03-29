Dashboard.helpers =
	subsReady: ->
		return Steedos.subsBootstrap.ready()
	dashboardId: ->
		return Session.get("dashboardId")
	spaceId: ->
		return Steedos.spaceId()
	currentDashboardName: ->
		dashboardId = Session.get("dashboardId")
		return db.portal_dashboards.findOne({_id:dashboardId})?.name
	isSidebarNeedShow: ->
		return Steedos.isCloudAdmin()
	addNosidebarClass: ->
		unless Steedos.isCloudAdmin()
			return "no-sidebar"