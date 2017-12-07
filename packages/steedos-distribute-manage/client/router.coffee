checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in?redirect=' + context.path;

FlowRouter.route '/admin/distribute/flows',
	triggersEnter: [checkUserSigned],
	action: (params, queryParams)->
		BlazeLayout.render 'adminLayout',
			main: "admin_distribute_flows"