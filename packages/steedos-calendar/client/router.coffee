checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in?redirect=' + context.path;


calendarSpaceRoutes = FlowRouter.group
	triggersEnter: [ checkUserSigned ],
	prefix: '/calendar',
	name: 'calendar'

calendarSpaceRoutes.route '/',
	action: (params, queryParams)->
		BlazeLayout.render 'calendarLayout',
			main: "calendarContainer"
	

