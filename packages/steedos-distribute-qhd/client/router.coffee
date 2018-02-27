checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		Steedos.redirectToSignIn(context.path)

FlowRouter.route '/admin/distribute/flows',
	triggersEnter: [checkUserSigned],
	action: (params, queryParams)->
		BlazeLayout.render 'adminLayout',
			main: "admin_distribute_flows"