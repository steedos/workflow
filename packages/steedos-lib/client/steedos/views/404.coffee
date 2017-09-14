Template.not_found.helpers
	iconUrl: ->
		return Steedos.absoluteUrl("/packages/steedos_theme/client/images/icon.png")

	isShowInfo: ->
		return Steedos.isMobile() or Steedos.isAndroidOrIOS()