Template['replace_AdminDashboard'].replaces('AdminDashboard');


Template.AdminDashboard.onRendered ->
	FlowRouter.go("/steedos/admin")