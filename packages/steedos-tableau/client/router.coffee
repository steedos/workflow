checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		Steedos.redirectToSignIn(context.path)

recordsQHDRoutes = FlowRouter.group
	prefix: '/tableau',
	name: 'tableau',
	triggersEnter: [checkUserSigned],
# subscriptions: (params, queryParams) ->
# 	if params.spaceId
# 		this.register 'apps', Meteor.subscribe("apps", params.spaceId)
# 		this.register 'space_users', Meteor.subscribe("space_users", params.spaceId)
# 		this.register 'organizations', Meteor.subscribe("organizations", params.spaceId)
# 		this.register 'flow_roles', Meteor.subscribe("flow_roles", params.spaceId)
# 		this.register 'flow_positions', Meteor.subscribe("flow_positions", params.spaceId)

# 		this.register 'categories', Meteor.subscribe("categories", params.spaceId)
# 		this.register 'forms', Meteor.subscribe("forms", params.spaceId)
# 		this.register 'flows', Meteor.subscribe("flows", params.spaceId)
recordsQHDRoutes.route '/',
	action: (params, queryParams)->
		FlowRouter.go '/tableau/info'

recordsQHDRoutes.route '/info',
	action: (params, queryParams)->
#		Steedos.setSpaceId(params.spaceId)
		BlazeLayout.render 'adminLayout',
			main: "tableau_info"

recordsQHDRoutes.route '/workflow',
	action: (params, queryParams)->
#		Steedos.setSpaceId(params.spaceId)
		BlazeLayout.render 'adminLayout',
			main: "tableau_flow_list"