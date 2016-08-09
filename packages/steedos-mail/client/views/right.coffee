Template.layout_right.helpers
	isComPose: ->
		return Session.get("mailBox") == "compose"
	isRead: ->
		return Session.get("mailMessageId")