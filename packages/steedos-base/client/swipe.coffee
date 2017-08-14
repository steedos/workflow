Meteor.startup ->
	# 手机上左右滑动切换sidebar
	unless Steedos.isMobile()
		return
	isSwiping = false
	loapTime = 0
	loapX = 0
	swipeStartTime = 0
	sidebarSelector = ".main-sidebar"
	contentWrapperSelector = ".skin-admin-lte>.wrapper>.content-wrapper"
	$("body").on("swipe", (event, options)->
		unless $(".main-sidebar").length
			return
		if options.direction != "left" and options.direction != "right"
			return
		else if options.direction == "right" and $("body").hasClass('sidebar-open')
			return
		else if options.direction == "left" and !$("body").hasClass('sidebar-open')
			return
		isSwiping = true
		swipeStartTime = options.startEvnt.time
	);
	$("body").on("swipeend", (event, options)->
		unless isSwiping
			return
		isSwiping = false
		$(sidebarSelector).css("transform","")
		$(contentWrapperSelector).css("transform","")
		action = ""
		if loapTime - swipeStartTime > 1000
			# 长按移动时间超过1s则以最后停留位置为准决定打开或关闭左侧菜单
			if loapX > 100
				action = "open"
			else
				action = "close"
		else if options.direction == "right"
			action = "open"
		else
			action = "close"

		if action == "open"
			unless $("body").hasClass('sidebar-open')
				$("body").addClass('sidebar-open')
		else if action == "close"
			if $("body").hasClass('sidebar-open')
				$("body").removeClass('sidebar-open');
				$("body").removeClass('sidebar-collapse')
	);
	$("body").on("tapmove", (event, options)->
		unless isSwiping
			return
		offsetX = options.position.x - loapX
		if options.time - loapTime > 100 and (offsetX > 10 || offsetX < -10)
			loapTime = options.time
			loapX = options.position.x

			if isSwiping
				if loapX > 230 
					loapX = 230
				$(sidebarSelector).css("transform","translate(#{-(230-loapX)}px, 0)")
				$(contentWrapperSelector).css("transform","translate(#{loapX}px, 0)")
	);

	# swipe相关事件不支持在Template.xxx.events中集成
	# 某些界面不需要左右滑动切换左侧sidebar功能，而需要向右滑动来触发返回上一界面功能
	isSwipeBacking = false
	Steedos.bindSwipeBackEvent = (selector, fun)->
		# 为阻止向右滑动打开左侧sidebar功能，需要同时阻止touchmove/tapmove、swipe、swiperight(如果有绑定该事件的话)事件冒泡
		$(selector).on("tapmove", (event, options)->
			# swipe事件的event.stopPropagation功能，需要额外阻止touchmove事件冒泡来达到
			event.stopPropagation()
		)
		$(selector).on("swipe", (event, options)->
			event.stopPropagation()
			if options.startEvnt.position.x < 40
				isSwipeBacking = true
		)
		$(selector).on("swipeend", (event, options)->
			event.stopPropagation()
			unless isSwipeBacking
				return
			isSwipeBacking = false
			if options.direction == "right" and fun
				fun(event, options)
		)
