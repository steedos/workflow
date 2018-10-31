Template.iframeLayout.helpers 
	
	subsReady: ->
		return Steedos.subsBootstrap.ready()


Template.iframeLayout.events

Template.iframeLayout.onCreated ()->
	###
	#为保险解决loading有时一直不消失的问题去掉
	$("body").addClass("loading").addClass("iframe-loading")
	###

Template.iframeLayout.onRendered ()->
	###
	#为保险解决loading有时一直不消失的问题去掉
	$("#main_iframe").load ()->
		$("body").removeClass("loading").removeClass("iframe-loading")
	###
	# 去除客户端右击事件
	Steedos.forbidNodeContextmenu window, "#main_iframe"

