Template.iframeLayout.helpers 
	
	subsReady: ->
		return Steedos.subsBootstrap.ready()


Template.iframeLayout.events

Template.iframeLayout.onCreated ()->
	$("body").addClass("loading").addClass("iframe-loading")

Template.iframeLayout.onRendered ()->
	$("#main_iframe").load ()->
		$("body").removeClass("loading").removeClass("iframe-loading")
		if Steedos.isNode()
			# 去除客户端右击事件
			ifrBody = $("#main_iframe").contents().find("body")
			if ifrBody
				ifrBody[0].addEventListener 'contextmenu', (ev) ->
					ev.preventDefault()
					return false

