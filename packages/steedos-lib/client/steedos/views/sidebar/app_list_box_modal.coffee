Template.app_list_box_modal.helpers

	getSpaceId: ()->

		spaceId = Session.get("spaceId")
		if spaceId
			return spaceId

		spaceId = localStorage.getItem("spaceId:" + Meteor.userId())
		if spaceId
			return spaceId
		else
			return undefined;

	apps: ()->
		return Steedos.getSpaceApps()

	getBadge: (appId, spaceId)->
		if !appId
			return;
		badge = 0
		if appId == "chat"
			subscriptions = db.rocketchat_subscription.find().fetch()
			_.each subscriptions, (s)->
				badge = badge + s.unread
		else 
			if spaceId
				b = db.steedos_keyvalues.findOne({user: Meteor.userId(), space: spaceId, key: "badge"})
				if b
					badge = b.value?[appId]
			else
				b = db.steedos_keyvalues.findOne({user: Meteor.userId(), space: null, key: "badge"})
				if b
					badge = b.value?[appId]
		if badge 
			return badge


Template.app_list_box_modal.onRendered ->
	$(".app-list-box-modal-body").css("max-height", ($(window).height()-140) + "px");

Template.app_list_box_modal.events

	'click .weui_grid': (event)->
        Modal.hide('app_list_box_modal'); 