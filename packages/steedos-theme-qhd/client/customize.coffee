if Meteor.isClient

	Template.atTitle.onRendered ->
		this.autorun ->
			path = Session.get("router-path")
			Tracker.afterFlush ->
				if path == "/steedos/sign-in"
					$(".at-form .at-title h3").html("河北港口集团协同办公系统")