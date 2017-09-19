Template.springboard.helpers

	apps: ()->
		return Steedos.getSpaceApps()


Template.springboard.events

	'click .weui_grids .weui_grid': (event)->
		Steedos.openApp event.currentTarget.dataset.appid


Template.springboard.onRendered ->
	contentWrapper = $(".skin-admin-lte>.wrapper>.content-wrapper")
	contentWrapper.addClass("no-sidebar")

Template.springboard.onDestroyed ->
	contentWrapper = $(".skin-admin-lte>.wrapper>.content-wrapper")
	contentWrapper.removeClass("no-sidebar")


