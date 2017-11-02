_.extend Steedos,

	openWindow: (url, target, options)->
		unless target
			target = "new_blank"
		unless options
			options = 'scrollbars=yes,EnableViewPortScale=yes,toolbarposition=top,transitionstyle=fliphorizontal,menubar=yes,closebuttoncaption=  x  '

		if Steedos.isAndroidOrIOS() || Steedos.isMobile() || Steedos.isCordova()
			if url.indexOf('X-User-Id') < 0 || url.indexOf('X-Auth-Token') < 0
				authToken = {};
				authToken["X-User-Id"] = Meteor.userId();
				authToken["X-Auth-Token"] = Accounts._storedLoginToken();
				if url.indexOf("?") < 0
					url = url + "?" + $.param(authToken)
				else
					url = url + "&" + $.param(authToken)


		window.open(url, target, options);

	# 左侧sidebar滚动条自适应
	fixSideBarScroll: ()->
		if Steedos.isMobile() || Steedos.isPad()
			return
		if !$(".sidebar").perfectScrollbar
			return
		if $("body").hasClass("sidebar-collapse")
			if $(".sidebar").hasClass("ps-container")
				$(".sidebar").perfectScrollbar("destroy")
		else if $("body").hasClass('sidebar-open')
			unless $(".sidebar").hasClass("ps-container")
				$(".sidebar").perfectScrollbar()
				$(".sidebar-menu").css("width", "100%");
		else
			unless $(".sidebar").hasClass("ps-container")
				$(".sidebar").perfectScrollbar()
				$(".sidebar-menu").css("width", "100%");

	goHome: ()->
		console.log "goHome_main"
		if !Meteor.userId()
			FlowRouter.go "/steedos/sign-in";
		else
			# # 登录最近关闭的URL
			# lastUrl = localStorage.getItem('Steedos.lastURL:' + Meteor.userId())
			# # 这时不能用lastUrl.startsWith，因为那样无法判断后面是否加了其他字符
			# if (!Steedos.isMobile() && lastUrl)
			# 	if /^\/?workflow\b/.test(lastUrl)
			# 		FlowRouter.go "/workflow"
			# 	else if /^\/?cms\b/.test(lastUrl)
			# 		FlowRouter.go "/cms"
			# 	else if /^\/?emailjs\b/.test(lastUrl)
			# 		FlowRouter.go "/emailjs"
			# 	else if /^\/?contacts\b/.test(lastUrl)
			# 		FlowRouter.go "/contacts"
			# 	else if /^\/?portal\b/.test(lastUrl)
			# 		FlowRouter.go "/portal"
			# 	else 
			# 		FlowRouter.go "/admin"
			# else
			if (Steedos.isMobile())
				FlowRouter.go "/workflow"
			else
				Tracker.autorun (c)->
					firstApp = Steedos.getSpaceFirstApp()
					if !firstApp
						# 这里等待db.apps加载完成后，找到并进入第一个spaceApps的路由，在apps加载完成前显示loading界面
						BlazeLayout.render 'steedosLoading'
						$("body").addClass('loading')
					else
						c.stop()
						currentPath = FlowRouter.current().path
						if currentPath == "/"
							Steedos.openApp firstApp._id
