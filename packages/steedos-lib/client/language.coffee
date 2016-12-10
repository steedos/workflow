Meteor.startup ->

	Tracker.autorun (c) ->
		user = Meteor.user()
		locale = Steedos.getLocale()
		console.log "locale:#{locale}"
		if locale == "zh-cn"
			locale = "zh-CN"
			moment.locale("zh-cn")
		else
			locale = "en"
			moment.locale("en")

		Session.set("is_tap_loaded", false)
		console.log "TAPi18n.setLanguage...for:#{locale}"
		TAPi18n.setLanguage(locale)
			.done ->
				console.log "TAPi18n.setLanguage.done and is_tap_loaded"
				Session.set("is_tap_loaded", true)
			.fail (error_message)->
				console.log(error_message)
