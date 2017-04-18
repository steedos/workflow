Template.baseTabbar.helpers
	appActive: (app)->
		if Steedos.getAppName() == app
			return "weui-bar__item_on"