Template.registerHelpers = (dict) ->
	_.each dict, (v, k)->
		Template.registerHelper k, v

Steedos.Helpers = 
	steedosAppTitle: ()->
		return Session.get("app_title")

	steedosUserId: ()->
		return Meteor.userId()

	steedosLocale: ()->
		return Session.get("steedos-locale")
				
Template.registerHelpers Steedos.Helpers
