Template.space_switcher.helpers

	spaces: ->
		return db.spaces.find();

	spaceName: ->
		if Session.get("spaceId")
			space = db.spaces.findOne(Session.get("spaceId"))
			if space
				return space.name
		return t("Steedos")


Template.space_switcher.events

	"click .switchSpace": ->
		Steedos.setSpaceId(this._id)
		path = Session.get("router-path")
		# 先进根路由再重新进当前路由,这样就可以触发当前路由的进入事件,重新做相关判断,比如权限判断
		FlowRouter.go "/"
		FlowRouter.go path

Template.space_switcher.onRendered ->
	$(".dropdown .dropdown-menu").css("max-height", ($(window).height()-120) + "px");