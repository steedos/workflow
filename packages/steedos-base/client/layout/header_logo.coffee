Template.steedosHeaderLogo.helpers
	spaceAvatar: ->
		avatar = db.spaces.findOne(Steedos.spaceId()).avatar
		return Steedos.absoluteUrl("/api/files/avatars/#{avatar}")

Template.steedosHeaderLogo.events
	'click .logo': (event) ->
		Modal.show "app_list_box_modal"