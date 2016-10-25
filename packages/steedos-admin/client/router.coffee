checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in';

adminRoutes = FlowRouter.group
	triggersEnter: [ checkUserSigned ],
	prefix: '/steedos_admin',
	name: 'adminRoutes'


adminRoutes.route '/',
	action: (params, queryParams)->
		FlowRouter.go "/steedos/profile"
		BlazeLayout.render 'steedosAdminLayout',
			main: "steedos_admin_home"


