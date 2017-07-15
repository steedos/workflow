Template.baseTabbar.helpers
	appActive: (app)->
		if app == "workflow"
			reg = /^\/?workflow\b/
		else if app == "cms"
			reg = /^\/?cms\b/
		else if app == "springboard"
			reg = /^\/?springboard\b/
		else if app == "admin"
			reg = /^\/?admin\b/

		if reg and reg.test(Session.get("router-path"))
			return "weui-bar__item_on"