Template.springboard.helpers

	apps: ()->
        return Steedos.getSpaceApps()


Template.springboard.events

	'click .weui_grids .weui_grid': (event)->
		Steedos.openApp event.currentTarget.dataset.appid