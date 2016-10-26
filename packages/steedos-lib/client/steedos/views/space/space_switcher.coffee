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
