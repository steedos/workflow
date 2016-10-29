Template.admin_space_switcher.helpers

	spaces: ->
		return db.spaces.find();

	spaceName: ->
		if Session.get("spaceId")
			space = db.spaces.findOne(Session.get("spaceId"))
			if space
				return space.name
		return t("Steedos")


Template.admin_space_switcher.events

	"click .switchSpace": ->
		Steedos.setSpaceId(this._id)
		FlowRouter.go("/admin/profile")

Template.admin_space_switcher.onRendered ->
	$(".dropdown .dropdown-menu").css("max-height", ($(window).height()-120) + "px");