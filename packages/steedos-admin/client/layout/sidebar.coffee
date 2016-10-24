Template.adminSidebar.helpers

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

	boxName: ->
		if Session.get("box")
			return t(Session.get("box"))

	boxActive: (box)->
		if box == Session.get("box")
			return "active"

	menuClass: (urlTag)->
		path = Session.get("router-path")
		if path?.startsWith "/" + urlTag or path?.startsWith "/steedos/" + urlTag
			return "active";

Template.adminSidebar.events

	'click .main-header .logo': (event) ->
		Modal.show "app_list_box_modal"