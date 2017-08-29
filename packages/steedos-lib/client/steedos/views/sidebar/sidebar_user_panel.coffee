Template.sidebarUserPanel.helpers

	displayName: ->
		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "

	avatar: () ->
		return Meteor.user()?.avatar

	avatarURL: (avatar) ->
		return Steedos.absoluteUrl("avatar/#{Meteor.userId()}?w=50&h=50&fs=30&avatar=#{avatar}");

	noneUploadedPicture: ->
		user = Meteor.user()
		unless user
			return ""
		return if user.avatar then "" else "none-uploaded-picture"

	spaceAvatar: ->
		avatar = db.spaces.findOne(Steedos.spaceId())?.avatar
		if avatar
			return Steedos.absoluteUrl("/api/files/avatars/#{avatar}")
		else
			return Steedos.absoluteUrl(Theme.space_logo)

Template.sidebarUserPanel.events

	'click .top-sidebar': ()->
		$("#sidebarOffcanvas").click();
		FlowRouter.go("/springboard");