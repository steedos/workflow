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
		# 因其他模块（比如portal）可能默认会折叠左侧菜单，这里强行展开，每次进入设置模块就默认展开菜单了
		$("body").removeClass("sidebar-collapse")

FlowRouter.route '/admin/home',
	action: (params, queryParams)->
		BlazeLayout.render 'adminLayout',
			main: "admin_home"

FlowRouter.route '/admin/organizations',
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		BlazeLayout.render 'adminLayout',
			main: "admin_org_main"
