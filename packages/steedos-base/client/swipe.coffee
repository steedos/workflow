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
	$("body").on("swipe", (event,options)->
		unless $(options.startEvnt.target).closest(contentWrapperSelector).length
			return
		isSwiping = true
		swipeStartTime = options.startEvnt.time
	);
	$("body").on("swipeend", (event,options)->
		isSwiping = false
		unless $(options.startEvnt.target).closest(contentWrapperSelector).length
			return
		$(sidebarSelector).css("transform","")
		$(contentWrapperSelector).css("transform","")
		action = ""
		if loapTime - swipeStartTime > 1000
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
	$("body").on("tapmove", (event,options)->
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