Template.steedosHeaderAccount.helpers
	displayName: ->
		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "

	avatar: () ->
		return Meteor.user()?.avatar

	avatarURL: (avatar,w,h,fs) ->
		return Steedos.absoluteUrl("avatar/#{Meteor.userId()}?w=#{w}&h=#{h}&fs=#{fs}&avatar=#{avatar}");

	signOutUrl: ()->
		return Steedos.absoluteUrl("steedos/sign-out")

Template.steedosHeaderAccount.events
	'click .btn-logout': (event,template) ->
		$("body").addClass("loading")