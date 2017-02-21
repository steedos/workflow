checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in';

fsshRoutes = FlowRouter.group
	triggersEnter: [ checkUserSigned ],
	prefix: '/fssh',
	name: 'fsshRoutes'


fsshRoutes.route '/',
	action: (params, queryParams)->
		FlowRouter.go "/fssh/accounts-guide"
		# $("body").addClass("sidebar-collapse")


fsshRoutes.route '/accounts-guide',
	action: (params, queryParams)->
		# $("body").addClass("sidebar-collapse")
		if Meteor.userId()
			BlazeLayout.render 'masterLayout',
				main: "accounts_guide"



