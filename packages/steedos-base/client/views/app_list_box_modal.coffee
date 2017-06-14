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

Template.app_list_box_modal.onRendered ->
	$(".app-list-box-modal-body").css("max-height", ($(window).height()-140) + "px");

Template.app_list_box_modal.events

	'click .weui_grids .weui_grid': (event)->
		Steedos.openApp event.currentTarget.dataset.appid
		Modal.hide('app_list_box_modal'); 