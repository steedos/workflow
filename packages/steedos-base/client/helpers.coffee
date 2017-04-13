import {moment} from 'meteor/momentjs:moment';
console.log(moment)

Steedos.Helpers = 

	isMobile: ()->
		return $(window).width() < 767

	isPad: ()->
		return /iP(ad)/.test(navigator.userAgent)

	getAppTitle: ()->
		t = Session.get("app_title")
		if t
			return t
		else
			return "Steedos"

	getUserId: ()->
		return Meteor.userId()

	setAppTitle: (title)->
		Session.set("app_title", title);
		document.title = title;
		
	getLocale: ()->
		return Session.get("steedos-locale")
			

_.extend Steedos, Steedos.Helpers

Template.registerHelpers = (dict) ->
	_.each dict, (v, k)->
		Template.registerHelper k, v

Template.registerHelpers Steedos.Helpers
