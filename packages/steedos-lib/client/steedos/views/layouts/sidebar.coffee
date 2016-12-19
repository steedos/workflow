Template.sidebar.helpers
		
	displayName: ->

		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "
	
	avatar: ->
		return Meteor.absoluteUrl("/avatar/#{Meteor.userId()}?w=54&h=50&fs=30");

	spaceId: ->
		if Session.get("spaceId")
			return Session.get("spaceId")
		else
			return localStorage.getItem("spaceId:" + Meteor.userId())

Template.sidebar.events
	'click .main-header .logo': (event) ->
		Modal.show "app_list_box_modal"


