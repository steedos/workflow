checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in';

adminRoutes = FlowRouter.group
	triggersEnter: [ checkUserSigned ],
	prefix: '/steedos/admin',
	name: 'adminRoutes'


adminRoutes.route '/',
	action: (params, queryParams)->
		FlowRouter.go "/admin/home"

FlowRouter.route '/admin/home',
	action: (params, queryParams)->
		BlazeLayout.render 'adminLayout',
			main: "admin_home"

FlowRouter.route '/admin/organizations',
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		BlazeLayout.render 'adminLayout',
			main: "org_main"
