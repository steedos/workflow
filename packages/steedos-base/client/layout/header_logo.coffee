Template.steedosHeaderLogo.helpers
	spaceAvatar: ->
		avatar = db.spaces.findOne(Steedos.spaceId())?.avatar
		if avatar
			return Steedos.absoluteUrl("/api/files/avatars/#{avatar}")
		else
			return Steedos.absoluteUrl("/packages/steedos_base/client/images/huayan.png")

Template.steedosHeaderLogo.events
	'click .logo': (event) ->
		Modal.show "app_list_box_modal"