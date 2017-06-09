Template.dashboardSidebar.helpers
	liActive:(dashboardId)->
		currentDashboardId = Session.get "dashboardId"
		if dashboardId == currentDashboardId
			return "active"
	
	dashboardList: ()->
		spaceId = Steedos.spaceId()
		return db.portal_dashboards.find({space:spaceId}).fetch()

Template.dashboardSidebar.events
	"click .btn-new-dashboard":(event,template)->
		$(".btn-add-dashboard").click()

	"click .btn-edit-dashboard":(event,template)->
		dashboardId = Session.get "dashboardId"
		editDashboard = db.portal_dashboards.findOne({_id:dashboardId})
		Session.set 'cmDoc',editDashboard
		$(".btn-dashboard-edit").click()

	"click .btn-delete-dashboard":(event,template)->
		dashboardId = Session.get "dashboardId"
		AdminDashboard.modalDelete 'portal_dashboards', dashboardId,->
			FlowRouter.go "/dashboard/"
