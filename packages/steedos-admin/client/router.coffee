checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		Steedos.redirectToSignIn()

adminRoutes = FlowRouter.group
	triggersEnter: [ checkUserSigned ],
	prefix: '/steedos/admin',
	name: 'adminRoutes'


adminRoutes.route '/',
	action: (params, queryParams)->
		FlowRouter.go "/admin/home"
		# 因其他模块（比如portal）可能默认会折叠左侧菜单，这里强行展开，每次进入设置模块就默认展开菜单了
		$("body").removeClass("sidebar-collapse")

		# 移除选中状态并将展开的二级菜单收起来
		$(".treeview-menu a[class^='admin-menu-']").removeClass("selected")
		$(".treeview.active > a").trigger("click")
		$(".treeview").removeClass("active")

FlowRouter.route '/admin/home',
	action: (params, queryParams)->
		BlazeLayout.render 'adminLayout',
			main: "admin_home"

FlowRouter.route '/admin/organizations',
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		if Steedos.isMobile()
			BlazeLayout.render 'adminLayout',
				main: "org_main_mobile"
		else
			BlazeLayout.render 'adminLayout',
				main: "admin_org_main"
