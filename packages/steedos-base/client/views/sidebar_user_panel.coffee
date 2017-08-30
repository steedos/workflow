Template.sidebarUserPanel.helpers

	spaceAvatar: ->
		avatar = db.spaces.findOne(Steedos.spaceId())?.avatar
		if avatar
			return Steedos.absoluteUrl("/api/files/avatars/#{avatar}")
		else
			return Steedos.absoluteUrl(Theme.space_logo)

Template.sidebarUserPanel.events

	'click .top-sidebar': ()->
		FlowRouter.go("/springboard");