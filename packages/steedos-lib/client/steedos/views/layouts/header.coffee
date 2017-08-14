Template.masterHeader.helpers
	appBadge: (appId)->
		if appId == "workflow"
			return Steedos.getBadge("workflow")
		else if appId == "cms"
			return Steedos.getBadge("cms")
		else
			return ""

Template.masterHeader.events
	'click .menu-app-link': (event) ->
		Steedos.openApp event.currentTarget.dataset.appid

	'click .menu-apps-link': (event) ->
		Modal.show "app_list_box_modal"

	'click .steedos-help': (event) ->
		Steedos.showHelp();