checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in';

accountsRoutes = FlowRouter.group
	triggersEnter: [ checkUserSigned ],
	prefix: '/accounts',
	name: 'accountsRoutes'

accountsRoutes.route '/',
	action: (params, queryParams)->
		FlowRouter.go "/accounts/setup/phone"

accountsRoutes.route '/setup/phone',
	action: (params, queryParams)->
		BlazeLayout.render 'loginLayout',
			main: "accounts_phone"

accountsRoutes.route '/setup/phone/verify',
	action: (params, queryParams)->
		BlazeLayout.render 'loginLayout',
			main: "accounts_phone_verify"

