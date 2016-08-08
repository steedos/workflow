checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in';

mailRoutes = FlowRouter.group
	prefix: '/mail',
	name: 'mailRoute',
	triggersEnter: [ checkUserSigned ],

mailRoutes.route '/', 
	action: (params, queryParams)->
		BlazeLayout.render 'masterLayout',
			main: "mail_home"

mailRoutes.route '/:box/', 
	action: (params, queryParams)->
		Session.set("box", params.box); 
		Session.set("messageId", null); 
		BlazeLayout.render 'masterLayout',
			main: "mail_home"

mailRoutes.route '/:box/read/:messageId', 
	action: (params, queryParams)->
		Session.set("box", params.box); 
		Session.set("messageId", params.messageId); 
		BlazeLayout.render 'masterLayout',
			main: "mail_home"