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

mailRoutes.route '/b/:mailBox/', 
	action: (params, queryParams)->
		Session.set("mailBox", params.mailBox); 
		Session.set("mailMessageId", null); 
		BlazeLayout.render 'masterLayout',
			main: "mail_home"

mailRoutes.route '/b/:mailBox/:mailMessageId', 
	action: (params, queryParams)->
		Session.set("mailBox", params.mailBox); 
		Session.set("mailMessageId", params.mailMessageId); 
		BlazeLayout.render 'masterLayout',
			main: "mail_home"