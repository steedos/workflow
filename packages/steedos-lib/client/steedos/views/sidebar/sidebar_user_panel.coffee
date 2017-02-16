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

Template.sidebarUserPanel.events