if Meteor.isClient
	Meteor.startup ->
		Theme.logo = "/packages/steedos_theme-qhd/client/images/logo.jpg"
		Theme.logo_en = Theme.logo
		Theme.icon = "/packages/steedos_theme-qhd/client/images/icon.png"
		Theme.icon_en = Theme.icon
		
		# 重置客户端版本号和下载网址
		Desktop.version = "3.1.9"
		Desktop.url = "http://192.1.1.238/digi/show.asp?infoid=42054"
	# qhd密码规则为至少6位
	Steedos.validatePassword = (pwd)->
		reason = t "password_invalid"
		valid = true
		unless pwd
			valid = false
		if pwd.length < 6
			valid = false
		if valid
			return true
		else
			return error:
				reason: reason

	# qhd首页定制
	Steedos.getHomeUrl = ()->
		if Steedos.isMobile()
			return "/springboard"
		else
			return "/dashboard"

	Template.atTitle.onRendered ->
		this.autorun ->
			path = Session.get("router-path")
			Tracker.afterFlush ->
				if path == "/steedos/sign-in"
					unless Steedos.isMobile()
						unless $(".content-wrapper .container").next(".log-tip")?.length
							$(".content-wrapper .container").after('<span class="log-tip" style="color: rgba(255, 255, 255, 0.5);position: absolute;left: 0px;bottom: 8px;width: 100%;text-align: center;font-weight: bolder;font-size: 18px;font-family: 华文仿宋,仿宋,cursive;">涉密信息不上网　上网信息不涉密</span>')
