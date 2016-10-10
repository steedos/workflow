Template.workflowSidebar.helpers

	displayName: ->

		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "
	 
	avatar: ->
		return Meteor.absoluteUrl("/avatar/" + Meteor.userId());

	spaceId: ->
		if Session.get("spaceId")
			return Session.get("spaceId")
		else
			return localStorage.getItem("spaceId:" + Meteor.userId())

	menuClass: (app_id)->
		path = Session.get("router-path")
		if path?.startsWith "/" + app_id or path?.startsWith "/app/" + app_id
			return "active";

	boxName: ->
		if Session.get("box")
			return t(Session.get("box"))

	boxActive: (box)->
		if box == Session.get("box")
			return "active"

Template.workflowSidebar.events

	'click .instance_new': (event, template)->
		#判断是否为欠费工作区
        if WorkflowManager.isArrearageSpace()
            toastr.error(t("spaces_isarrearageSpace"))
            return;

        Modal.show("flow_list_box_modal")

	'click [name="open_apps_btn"]': (event) ->
		Modal.show "app_list_box_modal"