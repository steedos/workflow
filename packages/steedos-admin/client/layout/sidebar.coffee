Admin.adminSidebarHelpers =

	spaceId: ->
		if Session.get("spaceId")
			return Session.get("spaceId")
		else
			return localStorage.getItem("spaceId:" + Meteor.userId())

	boxName: ->
		if Session.get("box")
			return t(Session.get("box"))

	boxActive: (box)->
		if box == Session.get("box")
			return "active"

	menuClass: (urlTag)->
		path = Session.get("router-path")
		if path?.startsWith "/" + urlTag or path?.startsWith "/steedos/" + urlTag
			return "active"

	isWorkflowAdmin: ()->
		if Steedos.isSpaceAdmin() then Steedos.getSpaceAppById("workflow") else false

	isPortalAdmin: ()->
		return Steedos.getSpaceAppByUrl("/portal/home")

	sidebarMenu: ()->
		return Admin.menuTemplate.getSidebarMenuTemplate()

	homeMenu: ()->
		if Steedos.isMobile()
			return Admin.menuTemplate.getHomeTemplateMobile()
		else
			return Admin.menuTemplate.getHomeTemplatePc()


Template.adminSidebar.helpers Admin.adminSidebarHelpers

Template.adminSidebar.events
	'click .fix-collection-helper a': (event) ->
		# 因部分admin列表界面在进入路由的时候会出现控制台报错：data[a[i]] is not a function
		# 且只有从admin列表界面进入到admin列表界面时才可能会报上面的错误信息
		# 所以这里加上fix-collection-helper样式类内的a链接先额外跳转到一个非admin列表界面，然后再让其自动跳转到href界面，这样可以避开错误信息
		FlowRouter.go("/admin/home")

	'click .steedos-help': (event) ->
		Steedos.showHelp();

	'click .header-app': (event) ->
		FlowRouter.go "/admin/home/"
		if Steedos.isMobile()
			# 手机上可能菜单展开了，需要额外收起来
			$("body").removeClass("sidebar-open")

Admin.menuTemplate =

	getSidebarMenuTemplate: ()->
		reTemplates = db.admin_menus.find({parent:null}, {sort: {sort: 1}}).map (rootMenu, rootIndex) ->
			unless Admin.menuTemplate.checkMenu(rootMenu)
				return ""
			children = db.admin_menus.find({parent:rootMenu._id}, {sort: {sort: 1}})
			if children.count()
				items = children.map (menu, index) ->
					unless Admin.menuTemplate.checkMenu(menu)
						return ""
					$("body").off "click", ".admin-menu-#{menu._id}"
					$("body").on "click", ".admin-menu-#{menu._id}", (e)->
						if menu.paid && !Steedos.isPaidSpace()
							e.preventDefault()
							Steedos.spaceUpgradedModal()
							return;

						Admin.menuTemplate.addSelectedStyle menu.parent, menu._id

						if typeof menu.onclick == "function"
							menu.onclick()

					if menu.target
						targetStr = "target=#{menu.target}"
					else
						targetStr = ""
					return """
						<li class="admin-menu-li-#{menu._id}"><a class="admin-menu-#{menu._id}" href="#{menu.url}" #{targetStr}><i class="#{menu.icon}"></i><span>#{t(menu.title)}</span></a></li>
					"""
				return """
					<li class="treeview admin-menu-li-#{rootMenu._id}">
						<a href="javascript:void(0)" class="admin-menu-#{rootMenu._id}">
							<i class="#{rootMenu.icon}"></i>
							<span>#{t(rootMenu.title)}</span>
							<span class="pull-right-container">
								<i class="fa fa-angle-left pull-right"></i>
							</span>
						</a>
						<ul class="treeview-menu">
							#{items.join("")}
						</ul>
					</li>
				"""
			else
				if typeof rootMenu.onclick == "function"
					$("body").on "click", ".admin-menu-#{rootMenu._id}", ->
						rootMenu.onclick()

				if rootMenu.target
					targetStr = "target=#{rootMenu.target}"
				else
					targetStr = ""
				return """
					<li class="admin-menu-li-#{rootMenu._id}"><a class="admin-menu-#{rootMenu._id}" href="#{rootMenu.url}" #{targetStr}><i class="#{rootMenu.icon}"></i><span>#{t(rootMenu.title)}</span></a></li>
				"""
		return reTemplates.join("")

	getHomeTemplatePc: ()->
		reTemplates = db.admin_menus.find({parent:null}, {sort: {sort: 1}}).map (rootMenu, rootIndex) ->
			unless Admin.menuTemplate.checkMenu(rootMenu)
				return ""
			children = db.admin_menus.find({parent:rootMenu._id}, {sort: {sort: 1}})
			if children.count()
				items = children.map (menu, index) ->
					unless Admin.menuTemplate.checkMenu(menu)
						return ""
					if menu.target
						targetStr = "target=#{menu.target}"
					else
						targetStr = ""


					# QHD隐藏个人信息
					if menu._id == "profile" and Meteor.settings.public?.admin?.disableProfileInfo == true
						return ""
					else
						return """
							<div class="col-xs-4 col-sm-4 col-md-3 col-lg-2 admin-menu-col-#{menu._id}">
								<a href="#{menu.url}" class="admin-grid-item btn btn-block admin-menu-#{menu._id}" #{targetStr}>
									<div class="admin-grid-icon">
										<i class="#{menu.icon}"></i>
									</div>
									<div class="admin-grid-label">
										#{t(menu.title)}
									</div>
								</a>
							</div>
						"""
				return """
					<div class="row admin-grids admin-grids-#{rootMenu._id}">
						#{items.join("")}
					</div>
				"""
			else
				if rootMenu.target
					targetStr = "target=#{rootMenu.target}"
				else
					targetStr = ""
				return """
					<div class="row admin-grids admin-grids-#{rootMenu._id}">
						<div class="col-xs-4 col-sm-4 col-md-3 col-lg-2 admin-menu-col-#{rootMenu._id}">
							<a href="#{rootMenu.url}" class="admin-grid-item btn btn-block admin-menu-#{rootMenu._id}" #{targetStr}>
								<div class="admin-grid-icon">
									<i class="#{rootMenu.icon}"></i>
								</div>
								<div class="admin-grid-label">
									#{t(rootMenu.title)}
								</div>
							</a>
						</div>
					</div>
				"""

		if Steedos.isMobile()
			reTemplates.push """
				<div class="row admin-grids admin-grids-logout">
					<div class="col-xs-4 col-sm-4 col-md-3 col-lg-2 admin-menu-col-logout">
						<a href="/steedos/logout" class="admin-grid-item btn btn-block admin-menu-logout">
							<div class="admin-grid-icon">
								<i class="ion ion-log-out"></i>
							</div>
							<div class="admin-grid-label">
								#{t("Logout")}
							</div>
						</a>
					</div>
				</div>
			"""

		return reTemplates.join("")

	getHomeTemplateMobile: ()->
		reTemplates = db.admin_menus.find({parent:null}, {sort: {sort: 1}}).map (rootMenu, rootIndex) ->
			unless Admin.menuTemplate.checkMenu(rootMenu)
				return ""
			children = db.admin_menus.find({parent:rootMenu._id}, {sort: {sort: 1}})
			if children.count()
				items = children.map (menu, index) ->
					unless Admin.menuTemplate.checkMenu(menu)
						return ""

					$("body").off "click", ".weui-cell-#{menu._id}"
					$("body").on "click", ".weui-cell-#{menu._id}", (e)->
						Admin.menuTemplate.addSelectedStyle menu.parent, menu._id
						if typeof menu.onclick == "function"
							menu.onclick()

					if menu._id == "steedos_tableau" and Steedos.isMobile()
						menu.url = "javascript:void(0)"

					if menu._id == "workflow_designer" and Steedos.isMobile()
						menu.url = "javascript:void(0)"

					if menu.target
						targetStr = "target=#{menu.target}"
					else
						targetStr = ""

					if menu._id == "profile" and Meteor.settings.public?.admin?.disableProfileInfo == true
						return ""
					else
						return """
							<a class="weui-cell weui-cell_access weui-cell-#{menu._id}" href="#{menu.url}" #{targetStr}>
								<div class="weui-cell__hd">
									<i class="ion #{menu.icon}"></i>
								</div>
								<div class="weui-cell__bd weui-cell_primary">
									<p>#{t(menu.title)}</p>
								</div>
								<span class="weui-cell__ft"></span>
							</a>
						"""

				return """
					<div class="weui-panel">
						<div class="weui-panel__hd">#{t(rootMenu.title)}</div>
						<div class="weui-panel">
							<div class="weui-panel__bd">
								<div class="weui-media-box weui-media-box_small-appmsg">
									<div class="weui-cells">
										#{items.join("")}
									</div>
								</div>
							</div>
						</div>
					</div>
				"""
			else
				if rootMenu.target
					targetStr = "target=#{rootMenu.target}"
				else
					targetStr = ""
				return """
					<div class="weui-panel weui-panel-#{rootMenu._id}">
						<div class="weui-panel__bd">
							<div class="weui-media-box weui-media-box_small-appmsg">
								<div class="weui-cells">
									<a class="weui-cell weui-cell_access weui-cell-#{rootMenu._id}" href="#{rootMenu.url}" #{targetStr}>
										<div class="weui-cell__hd">
											<i class="ion #{rootMenu.icon}"></i>
										</div>
										<div class="weui-cell__bd weui-cell_primary">
											<p>#{t(rootMenu.title)}</p>
										</div>
										<span class="weui-cell__ft"></span>
									</a>
								</div>
							</div>
						</div>
					</div>
				"""

		extraFields = [{
			_id: "help",
			url: "javascript:;",
			icon: "ion-ios-help-outline",
			title: "Help"
		},{
			_id: "about",
			url: "/admin/about",
			icon: "ion-ios-information-outline",
			title: "steedos_about"
		},{
			_id: "logout",
			url: "/steedos/logout",
			icon: "ion-log-out",
			title: "Sign out"
		}]

		# if !Steedos.isSpaceAdmin()
		# 	extraFields.splice 0, 0,
		# 		_id: "steedos_tableau"
		# 		url: "javascript:void(0)"
		# 		icon: "ion-ios-pie-outline"
		# 		title: "steedos_tableau"
		# 		onclick: ->
		# 			if Steedos.isMobile()
		# 				swal({
		# 					title: t("workflow_designer_use_pc"),
		# 					confirmButtonText: t("OK")
		# 				})


		extraTemplates = extraFields.map (menu, index) ->
			if menu.onclick
				$("body").off "click", ".weui-cell-#{menu._id}"
				$("body").on "click", ".weui-cell-#{menu._id}", (e)->
					Admin.menuTemplate.addSelectedStyle menu.parent, menu._id
					if typeof menu.onclick == "function"
						menu.onclick()

			return """
				<div class="weui-panel weui-panel-#{menu._id}">
					<div class="weui-panel__bd">
						<div class="weui-media-box weui-media-box_small-appmsg">
							<div class="weui-cells">
								<a class="weui-cell weui-cell_access weui-cell-#{menu._id}" href="#{menu.url}">
									<div class="weui-cell__hd">
										<i class="ion #{menu.icon}"></i>
									</div>
									<div class="weui-cell__bd weui-cell_primary">
										<p>#{t(menu.title)}</p>
									</div>
									<span class="weui-cell__ft"></span>
								</a>
							</div>
						</div>
					</div>
				</div>
			"""

		return reTemplates.join("") + extraTemplates.join("")

	checkRoles: (menu)->
		unless menu
			return false
		isChecked = true
		if menu.app
			isChecked = !!Steedos.getSpaceAppById(menu.app)

		# if menu.app and menu.paid
		# 	# 未来是按APP收费，所以判断是否付费要求带上app属性
		# 	unless Steedos.isPaidSpace()
		# 		isChecked = false

		if isChecked and menu.roles?.length
			roles = menu.roles
			for i in [1..roles.length]
				role = roles[i-1]
				switch role
					when "space_admin"
						unless Steedos.isSpaceAdmin()
							isChecked = false
					when "space_owner"
						unless Steedos.isSpaceOwner()
							isChecked = false
					when "cloud_admin"
						unless Steedos.isCloudAdmin()
							isChecked = false
				unless isChecked
					break
			return isChecked
		return isChecked

	checkMenu: (menu)->
		unless Admin.menuTemplate.checkRoles(menu)
			return false

		if menu.mobile == false and Steedos.isMobile()
			return false

		return true

	addSelectedStyle: (parent, _id)->
		# 添加左侧菜单的选中效果
		$(".treeview-menu a[class^='admin-menu-']").removeClass("selected")
		$(".treeview-menu a.admin-menu-#{_id}").addClass("selected")
		unless $(".admin-menu-#{parent}").closest("li").hasClass("active")
			$(".admin-menu-#{parent}").trigger("click")

