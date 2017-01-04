###
# Kick off the global namespace for Steedos.
# @namespace Steedos
###

db = {}
Steedos = 
	settings: {}
	db: db

@TabularTables = {};

if Meteor.isClient

	Steedos.isMobile = ()->
		return $(window).width() < 767

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

	Steedos.showHelp = ()->
		locale = Steedos.getLocale()
		country = locale.substring(3)
		window.open("http://www.steedos.com/" + country + "/help/", '_help', 'EnableViewPortScale=yes')

	# 左侧sidebar滚动条自适应
	Steedos.fixSideBarScroll = ()->
		if Steedos.isMobile()
			return
		if !$("#scrollspy").perfectScrollbar
			return
		if $("body").hasClass("sidebar-collapse")
			if $("#scrollspy").hasClass("ps-container")
				$("#scrollspy").perfectScrollbar("destroy")
		else if $("body").hasClass('sidebar-open')
			unless $("#scrollspy").hasClass("ps-container")
				$("#scrollspy").perfectScrollbar()
		else
			unless $("#scrollspy").hasClass("ps-container")
				$("#scrollspy").perfectScrollbar()

	# 根据当前路由路径前缀，得到当前所属app名字
	Steedos.getAppNameFromRoutePath = (path)->
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

		Steedos.setAppId app_id
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
			if Steedos.isMobile()
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