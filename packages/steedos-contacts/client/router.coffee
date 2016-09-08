checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in';

mailRoutes = FlowRouter.group
	prefix: '/contacts',
	name: 'mailRoute',
	triggersEnter: [ checkUserSigned ],

mailRoutes.route '/', 
	action: (params, queryParams)->
		BlazeLayout.render 'masterLayout',
			main: "contacts_home"
