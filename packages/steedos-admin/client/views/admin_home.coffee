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

	'click .admin-menu-col-process_delegation_rules': (event) ->
		console.log "admin-menu-col-process_delegation_rules"
		if !Steedos.isLegalVersion('',"workflow.professional")
			Steedos.spaceUpgradedModal()
			return;
		FlowRouter.go('/admin/workflow/process_delegation_rules')