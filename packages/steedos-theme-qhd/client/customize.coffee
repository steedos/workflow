if Meteor.isClient

	Template.atTitle.onRendered ->
		this.autorun ->
			path = Session.get("router-path")
			Tracker.afterFlush ->
				if path == "/steedos/sign-in"
					$(".at-form .at-title h3").html("河北港口集团协同办公系统")
					unless $(".at-form .at-title").prev("img")?.length
						$(".at-form .at-title").before('<img src="/packages/steedos_theme-qhd/client/images/logo.jpg" class="img-circle logo" alt="logo" />')
