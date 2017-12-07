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
		if !Meteor.userId()
			FlowRouter.go "/steedos/sign-in";
		else
			if Steedos.isMobile()
				FlowRouter.go "/workflow"
			else
				Tracker.autorun (c)->
					if Steedos.subsBootstrap.ready() and Steedos.subsSpaceBase.ready()
						c.stop()
						forceAccountBindPhone = Meteor.settings?.public?.phone?.forceAccountBindPhone
						if forceAccountBindPhone and Steedos.isForceBindPhone and !Accounts.isPhoneVerified()
							# 未验证手机号时，强行跳转到手机号绑定界面
							setupUrl = "/accounts/setup/phone"
							FlowRouter.go setupUrl
						else
							firstApp = Steedos.getSpaceFirstApp()
							currentPath = FlowRouter.current().path
							if currentPath == "/"
								Steedos.openApp firstApp._id
					else if !Meteor.loggingIn()
						# 这里等待db.apps加载完成后，找到并进入第一个spaceApps的路由，在apps加载完成前显示loading界面
						BlazeLayout.render 'steedosLoading'
						$("body").addClass('loading')
