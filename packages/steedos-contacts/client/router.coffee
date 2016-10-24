checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in';

contactsRoutes = FlowRouter.group
	prefix: '/contacts',
	name: 'contactsRoutes',
	triggersEnter: [ checkUserSigned ],

contactsRoutes.route '/', 
	action: (params, queryParams)->
		BlazeLayout.render 'contactsLayout',
			main: "contacts_main"
