if Meteor.isClient
	Meteor.startup ->
		Theme.logo = "/packages/steedos_theme-qhd/client/images/logo.jpg"
		Theme.logo_en = Theme.logo
		Theme.icon = "/packages/steedos_theme-qhd/client/images/icon.png"
		Theme.icon_en = Theme.icon
		# qhd密码可以随便写
		Steedos.validatePassword = (pwd)->
			return true

	Template.atTitle.onRendered ->
		this.autorun ->
			path = Session.get("router-path")
			Tracker.afterFlush ->
				if path == "/steedos/sign-in"
					unless Steedos.isMobile()
						unless $(".content-wrapper .container").next(".log-tip")?.length
							$(".content-wrapper .container").after('<span class="log-tip" style="color: rgba(255, 255, 255, 0.5);position: absolute;left: 0px;bottom: 8px;width: 100%;text-align: center;font-weight: bolder;font-size: 18px;font-family: 华文仿宋,仿宋,cursive;">涉密信息不上网　上网信息不涉密</span>')
