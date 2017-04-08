getBrowserLocale = ()->
	l = window.navigator.userLanguage || window.navigator.language || 'en'
	if l.indexOf("zh") >=0
		locale = "zh-cn"
	else
		locale = "en-us"
	return locale

Tracker.autorun ()->
	Session.set("steedos-locale", getBrowserLocale())
	if Meteor.user()
		if Meteor.user().locale
			Session.set("steedos-locale",Meteor.user().locale)



Tracker.autorun ()->
	if Session.get("steedos-locale") == "zh-cn"
		TAPi18n.setLanguage("zh-CN")
	else
		TAPi18n.setLanguage("en")

	