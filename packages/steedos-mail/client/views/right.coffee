Template.layout_right.helpers
	isComPose: ->
		return Session.get("box") == "compose"
	isRead: ->
		return Session.get("messageId")