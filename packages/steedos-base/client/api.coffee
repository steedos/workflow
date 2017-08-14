_.extend Steedos,
	
	openWindow: (url, target)->
		debugger
		target = "new_blank"
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

