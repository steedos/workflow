Template.steedosHeaderLogo.helpers
	spaceAvatar: ->
		avatar = db.spaces.findOne(Steedos.spaceId())?.avatar
		if avatar
			return Steedos.absoluteUrl("/api/files/avatars/#{avatar}")
		else
			return Steedos.absoluteUrl(Theme.space_logo)

	isSpaceOwner: (event)->
		return Steedos.isSpaceOwner(Steedos.spaceId())

	logoMiniUrl: ()->
		return Theme.icon

Template.steedosHeaderLogo.events
	'click .logo': (event) ->

		if db.spaces.find().count() > 1
			Modal.show "space_switcher_modal"
		else
			Modal.show "app_list_box_modal"

	'click .edit-space': (event)->
		if Steedos.isSpaceOwner(Steedos.spaceId())
			AdminDashboard.modalEdit('spaces', Steedos.spaceId())

		event.stopPropagation()
#		event.preventDefault()