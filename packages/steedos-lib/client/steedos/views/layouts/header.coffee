Template.masterHeader.helpers

	displayName: ->

		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "
	
	avatar: () ->
		return Meteor.user()?.avatar

	avatarURL: (avatar,w,h,fs) ->
		return Steedos.absoluteUrl("avatar/#{Meteor.userId()}?w=#{w}&h=#{h}&fs=#{fs}&avatar=#{avatar}");

	spaceId: ->
		return Steedos.getSpaceId()

	workflowApp: ->
		return db.apps.findOne({_id:"workflow"})

	cmsApp: ->
		return db.apps.findOne({_id:"cms"})

	getBadgeForWorkflowApp: ->
		workflowApp = db.apps.findOne({_id:"workflow"})
		unless workflowApp
			return 0
		return Steedos.getBadge(workflowApp._id,null)

	getBadgeForCmsApp: ->
		cmsApp = db.apps.findOne({_id:"cms"})
		unless cmsApp
			return 0
		return Steedos.getBadge(cmsApp._id,null)

	isNode: ->
		return Steedos.isNode()


Template.masterHeader.events

	'click .main-header .logo': (event) ->
		Modal.show "app_list_box_modal"

	'click .steedos-help': (event) ->
		Steedos.showHelp();

	'click .btn-logout': (event,template) ->
		$("body").addClass("loading")
		toastr.clear $(".toast-info")

	'click .ion.ion-refresh' : (event) ->
		window.location.reload()