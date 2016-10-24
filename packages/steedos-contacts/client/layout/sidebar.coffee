Template.contactsSidebar.helpers

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

Template.contactsSidebar.events

	'click .main-header .logo': (event) ->
		Modal.show "app_list_box_modal"