Template.masterHeader.helpers

	displayName: ->

		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "
	
	avatar: ->
		return Meteor.absoluteUrl("/avatar/#{Meteor.userId()}?w=54&h=50&fs=30");

	spaceId: ->
		return Steedos.getSpaceId()


Template.masterHeader.events

	'click .main-header .logo': (event) ->
		Modal.show "app_list_box_modal"