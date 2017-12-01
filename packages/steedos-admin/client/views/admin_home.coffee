Template.admin_home.helpers Admin.adminSidebarHelpers

Template.admin_home.helpers
	adminTitle: ->
		if Steedos.isMobile()
			return t "tabbar_admin"
		else
			return t "Steedos Admin"

Template.admin_home.events
	'click .weui-cell-help':() ->
		Steedos.showHelp();