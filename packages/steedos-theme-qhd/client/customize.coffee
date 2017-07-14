if Meteor.isClient
	Template.atTitle.onRendered ->
		this.autorun ->
			path = Session.get("router-path")
			Tracker.afterFlush ->
				if path == "/steedos/sign-in"
					if Steedos.isMobile()
						$(".at-form .at-title h3").html("河港办公系统")
					else
						$(".at-form .at-title h3").html("河北港口集团协同办公系统")
						unless $(".at-form .at-title h3").next(".log-tip")?.length
							$(".at-form .at-title h3").after('<span class="log-tip" style="font-weight: bolder;font-size: 18px;font-family: 华文仿宋,仿宋,cursive;color: #fff;">涉密信息不上网　上网信息不涉密</span>')
					unless $(".at-form .at-title").prev("img")?.length
						$(".at-form .at-title").before('<img src="/packages/steedos_theme-qhd/client/images/logo.jpg" class="img-circle logo" alt="logo" />')
