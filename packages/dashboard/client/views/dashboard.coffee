Template.dashboardView.helpers Dashboard.helpers

# Template.dashboardView.onRendered ->
# 	$("body").addClass("sidebar-collapse")

Template.dashboardView.events
	"click .btn-edit-dashboard":(event,template)->
		dashboardId = Session.get "dashboardId"
		editDashboard = db.portal_dashboards.findOne({_id:dashboardId})
		Session.set 'cmDoc',editDashboard
		$(".btn-dashboard-edit").click()