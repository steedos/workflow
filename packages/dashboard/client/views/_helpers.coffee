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
		userId = Meteor.userId()
		spaceId = Steedos.spaceId()
		isSpaceAdmin = Steedos.isSpaceAdmin(spaceId,userId)
		if isSpaceAdmin
			return true
		else
			return false
	addNosidebarClass: ->
		userId = Meteor.userId()
		spaceId = Steedos.spaceId()
		isSpaceAdmin = Steedos.isSpaceAdmin(spaceId,userId)
		unless isSpaceAdmin
			return "no-sidebar"