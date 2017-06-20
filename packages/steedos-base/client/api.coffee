_.extend Steedos,
	
	openWindow: (url, target, options)->
		unless target
			target = "_blank"
		unless options
			options = 'scrollbars=yes,EnableViewPortScale=yes,toolbarposition=top,transitionstyle=fliphorizontal,closebuttoncaption=  x  '
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


if Meteor.isServer
	_.extend Steedos,
		locale: (userId, isI18n)->
			locale = db.users.findOne({_id:userId}).locale
			if isI18n
				if locale == "en-us"
					locale = "en"
				if locale == "zh-cn"
					locale = "zh-CN"
			return locale

