Template.steedosHeaderLogo.helpers
	spaceAvatar: ->
		avatar = db.spaces.findOne(Steedos.spaceId())?.avatar
		if avatar
			return Steedos.absoluteUrl("/api/files/avatars/#{avatar}")
		else
			locale = Steedos.locale()
			if locale == "zh-cn"
				return Steedos.absoluteUrl(Theme.space_logo)
			else
				return Steedos.absoluteUrl(Theme.space_logo_en)

	isSpaceOwner: (event)->
		return Steedos.isSpaceOwner(Steedos.spaceId())

	logoMiniUrl: ()->
		locale = Steedos.locale()
		if locale == "zh-cn"
			return Theme.icon
		else
			return Theme.icon_en

Template.steedosHeaderLogo.events
	'click .logo': (event) ->
		if db.spaces.find().count() > 1
			Modal.show "space_switcher_modal"
		else
			if Session.get("apps")
				# 如果有限制显示apps列表则不弹出apps切换窗口
				return
			Modal.show "app_list_box_modal"

	'click .edit-space': (event)->
		if Steedos.isSpaceOwner(Steedos.spaceId())
			AdminDashboard.modalEdit('spaces', Steedos.spaceId())

		event.stopPropagation()
#		event.preventDefault()