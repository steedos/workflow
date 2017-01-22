###
# Kick off the global namespace for Steedos.
# @namespace Steedos
###

db = {}
Steedos = 
	settings: {}
	db: db
	subs: {}

@TabularTables = {};

if Meteor.isClient

	Steedos.isMobile = ()->
		return $(window).width() < 767

	Steedos.isPad = ()->
		return /iP(ad)/.test(navigator.userAgent)

	Steedos.openWindow = (url, target)->
		target = "_blank"
		options = 'scrollbars=yes,EnableViewPortScale=yes,toolbarposition=top,transitionstyle=fliphorizontal,closebuttoncaption=  x  '
		window.open(url, target, options);

	Steedos.getAccountBgBodyValue = ()->
		accountBgBody = db.steedos_keyvalues.findOne({user:Steedos.userId(),key:"bg_body"})
		if accountBgBody
			return accountBgBody.value
		else
			return {};

	Steedos.getAccountSkinValue = ()->
		accountSkin = db.steedos_keyvalues.findOne({user:Steedos.userId(),key:"skin"})
		if accountSkin
			return accountSkin.value
		else
			return {};

	Steedos.getAccountZoomValue = ()->
		accountZoom = db.steedos_keyvalues.findOne({user:Steedos.userId(),key:"zoom"})
		if accountZoom
			return accountZoom.value
		else
			return {};

	Steedos.applyAccountZoomValue = (accountZoomValue,isNeedToLocal)->
		unless Steedos.userId()
			# 如果是登录界面，则取localStorage中字体设置，而不是直接应用空设置
			accountZoomValue = {}
			accountZoomValue.name = localStorage.getItem("accountZoomValue.name")
			accountZoomValue.size = localStorage.getItem("accountZoomValue.size")
		if SC.browser.isiOS
			if accountZoomValue.size
				$("meta[name=viewport]").attr("content","initial-scale=#{accountZoomValue.size}, user-scalable=no")
			else
				$("meta[name=viewport]").attr("content","initial-scale=1, user-scalable=no")
		else
			$("body").removeClass("zoom-normal").removeClass("zoom-large").removeClass("zoom-extra-large");
			if accountZoomValue.name
				$("body").addClass("zoom-#{accountZoomValue.name}")
		if isNeedToLocal
			# 这里特意不在localStorage中存储Steedos.userId()，因为需要保证登录界面也应用localStorage中的字体设置
			# 登录界面不设置localStorage，因为登录界面accountZoomValue肯定为空，设置的话，会造成无法保持登录界面也应用localStorage中的字体设置
			if Steedos.userId()
				if accountZoomValue.name
					localStorage.setItem("accountZoomValue.name",accountZoomValue.name)
					localStorage.setItem("accountZoomValue.size",accountZoomValue.size)
				else
					localStorage.removeItem("accountZoomValue.name")
					localStorage.removeItem("accountZoomValue.size")

	Steedos.showHelp = ()->
		locale = Steedos.getLocale()
		country = locale.substring(3)
		window.open("http://www.steedos.com/" + country + "/help/", '_help', 'EnableViewPortScale=yes')

	# 左侧sidebar滚动条自适应
	Steedos.fixSideBarScroll = ()->
		if Steedos.isMobile() || Steedos.isPad()
			return
		if !$(".sidebar").perfectScrollbar
			return
		console.log("fixSideBarScroll");
		if $("body").hasClass("sidebar-collapse")
			if $(".sidebar").hasClass("ps-container")
				$(".sidebar").perfectScrollbar("destroy")
		else if $("body").hasClass('sidebar-open')
			unless $(".sidebar").hasClass("ps-container")
				$(".sidebar").perfectScrollbar()
				$(".sidebar-menu").css("width", "100%");
		else
			unless $(".sidebar").hasClass("ps-container")
				$(".sidebar").perfectScrollbar()
				$(".sidebar-menu").css("width", "100%");

	# 根据当前路由路径前缀，得到当前所属app名字
	Steedos.getAppName = (path)->
		unless path
			path = FlowRouter.current().path
		if /^\/?workflow\b/.test(path)
			return "workflow"
		else if /^\/?cms\b/.test(path)
			return "cms"
		else if /^\/?emailjs\b/.test(path)
			return "emailjs"
		else if /^\/?contacts\b/.test(path)
			return "contacts"
		else if /^\/?portal\b/.test(path)
			return "portal"
		else if /^\/?admin\b/.test(path)
			return "admin"
		else
			return ""

	Steedos.openApp = (app_id)->
		if !Meteor.userId()
			FlowRouter.go "/steedos/sign-in";
			return true
		
		app = db.apps.findOne(app_id)
		if !app
			FlowRouter.go("/steedos/springboard")
			return

		on_click = app.on_click
		if app.is_use_ie
			if Steedos.isNode()
				exec = nw.require('child_process').exec
				if on_click
					path = "api/app/sso/#{app_id}?authToken=#{Accounts._storedLoginToken()}&userId=#{Meteor.userId()}"
					open_url = Meteor.absoluteUrl(path)
				else
					open_url = app.url
				cmd = "start iexplore.exe \"#{open_url}\""
				exec cmd, (error, stdout, stderr) ->
					if error
						toastr.error error
					return

			return
		if on_click
			# 这里执行的是一个不带参数的闭包函数，用来避免变量污染
			evalFunString = "(function(){#{on_click}})()"
			try
				eval(evalFunString)
			catch e
				# just console the error when catch error
				console.error "catch some error when eval the on_click script for app link:"
				console.error "#{e.message}\r\n#{e.stack}"
		else
			if app.internal
				FlowRouter.go(app.url)
				return

			authToken = {};
			authToken["spaceId"] = Steedos.getSpaceId()
#			if Steedos.isMobile()
			authToken["X-User-Id"] = Meteor.userId();
			authToken["X-Auth-Token"] = Accounts._storedLoginToken();

			url = Meteor.absoluteUrl("api/setup/sso/" + app._id + "?" + $.param(authToken));

			Steedos.openWindow(url);

	Steedos.checkSpaceBalance = (spaceId)->
		unless spaceId
			spaceId = Steedos.spaceId()
		min_months = 1
		if Steedos.isSpaceAdmin()
			min_months = 3
		space = db.spaces.findOne(spaceId)
		remaining_months = space?.billing?.remaining_months
		if space?.is_paid and remaining_months != undefined and remaining_months <= min_months
			# 提示用户余额不足
			toastr.error t("space_balance_insufficient")

	Steedos.getModalMaxHeight = (offset)->
		reValue = $(window).height() - 180 - 25
		unless SC.browser.isiOS or Steedos.isMobile()
			# ios及手机上不需要为zoom放大功能额外计算
			accountZoomValue = Steedos.getAccountZoomValue()
			switch accountZoomValue.name
				when 'large'
					console.log "Steedos.getModalMaxHeight - large -0"
					# 测下来这里不需要额外减数
					reValue -= 0
				when 'extra-large'
					console.log "Steedos.getModalMaxHeight - extra-large -25"
					reValue -= 25
		if offset
			reValue -= offset
		return reValue + "px";




	#定义系统关闭函数，下次登录时自动跳转URL
	window.onunload = ()->
		# 判断用户是否登录
		if Meteor.userId()
			lastUrl = FlowRouter.current().path
			localStorage.setItem('Steedos.lastURL:' + Meteor.userId(), lastUrl)


if Meteor.isServer
	#TODO 添加服务端是否手机的判断(依据request)
	Steedos.isMobile = ()->
		return false;

	Steedos.isSpaceAdmin = (spaceId, userId)->
		if !spaceId || !userId
			return false
		space = db.spaces.findOne(spaceId)
		if !space || !space.admins
			return false;
		return space.admins.indexOf(userId)>=0

	# 判断数组orgIds中的org id集合对于用户userId是否有组织管理员权限，只要数组orgIds中任何一个组织有权限就返回true，反之返回false
	Steedos.isOrgAdminByOrgIds = (orgIds, userId)->
		isOrgAdmin = false
		useOrgs = db.organizations.find({_id: {$in:orgIds}},{fields:{parents:1,admins:1}}).fetch()
		parents = []
		allowAccessOrgs = useOrgs.filter (org) ->
			if org.parents
				parents = _.union parents,org.parents
			return org.admins?.includes(userId)
		if allowAccessOrgs.length
			isOrgAdmin = true
		else
			parents = _.flatten parents
			parents = _.uniq parents
			if parents.length and db.organizations.findOne({_id:{$in:parents}, admins:{$in:[userId]}})
				isOrgAdmin = true
		return isOrgAdmin


	# 判断数组orgIds中的org id集合对于用户userId是否有全部组织管理员权限，只有数组orgIds中每个组织都有权限才返回true，反之返回false
	Steedos.isOrgAdminByAllOrgIds = (orgIds, userId)->
		unless orgIds.length
			return true
		i = 0
		while i < orgIds.length
			isOrgAdmin = Steedos.isOrgAdminByOrgIds [orgIds[i]], userId
			unless isOrgAdmin
				break
			i++
		return isOrgAdmin


# This will add underscore.string methods to Underscore.js
# except for include, contains, reverse and join that are 
# dropped because they collide with the functions already 
# defined by Underscore.js.

mixin = (obj) ->
	_.each _.functions(obj), (name) ->
		if not _[name] and not _.prototype[name]?
			func = _[name] = obj[name]
			_.prototype[name] = ->
				args = [this._wrapped]
				push.apply(args, arguments)
				return result.call(this, func.apply(_, args))

#mixin(_s.exports())