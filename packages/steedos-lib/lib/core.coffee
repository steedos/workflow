###
# Kick off the global namespace for Steedos.
# @namespace Steedos
###

@TabularTables = {};

if Meteor.isClient

	Steedos.getAccountBgBodyValue = ()->
		accountBgBody = db.steedos_keyvalues.findOne({user:Steedos.userId(),key:"bg_body"})
		if accountBgBody
			return accountBgBody.value
		else
			return {};

	Steedos.applyAccountBgBodyValue = (accountBgBodyValue,isNeedToLocal)->
		if Meteor.loggingIn() or !Steedos.userId()
			# 如果是正在登录中或在登录界面，则取localStorage中设置，而不是直接应用空设置
			accountBgBodyValue = {}
			accountBgBodyValue.url = localStorage.getItem("accountBgBodyValue.url")
			accountBgBodyValue.avatar = localStorage.getItem("accountBgBodyValue.avatar")

		url = accountBgBodyValue.url
		avatar = accountBgBodyValue.avatar
		if accountBgBodyValue.url
			if url == avatar
				$("body").css "backgroundImage","url(#{Steedos.absoluteUrl('api/files/avatars/' + avatar)})"
			else
				$("body").css "backgroundImage","url(#{url})"
		else
			background = Meteor.settings?.public?.admin?.background
			if background
				$("body").css "backgroundImage","url(#{background})"
			else
				$("body").css "backgroundImage","url('/packages/steedos_theme/client/background/flower.jpg')"

		if isNeedToLocal
			if Meteor.loggingIn()
				# 正在登录中，则不做处理，因为此时Steedos.userId()不足于证明已登录状态
				return
			# 这里特意不在localStorage中存储Steedos.userId()，因为需要保证登录界面也应用localStorage中的设置
			# 登录界面不设置localStorage，因为登录界面accountBgBodyValue肯定为空，设置的话，会造成无法保持登录界面也应用localStorage中的设置
			if Steedos.userId()
				if url
					localStorage.setItem("accountBgBodyValue.url",url)
					localStorage.setItem("accountBgBodyValue.avatar",avatar)
				else
					localStorage.removeItem("accountBgBodyValue.url")
					localStorage.removeItem("accountBgBodyValue.avatar")

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
		if Meteor.loggingIn() or !Steedos.userId()
			# 如果是正在登录中或在登录界面，则取localStorage中设置，而不是直接应用空设置
			accountZoomValue = {}
			accountZoomValue.name = localStorage.getItem("accountZoomValue.name")
			accountZoomValue.size = localStorage.getItem("accountZoomValue.size")

		$("body").removeClass("zoom-normal").removeClass("zoom-large").removeClass("zoom-extra-large");
		if accountZoomValue.name
			$("body").addClass("zoom-#{accountZoomValue.name}")
		if isNeedToLocal
			if Meteor.loggingIn()
				# 正在登录中，则不做处理，因为此时Steedos.userId()不足于证明已登录状态
				return
			# 这里特意不在localStorage中存储Steedos.userId()，因为需要保证登录界面也应用localStorage中的设置
			# 登录界面不设置localStorage，因为登录界面accountZoomValue肯定为空，设置的话，会造成无法保持登录界面也应用localStorage中的设置
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


	Steedos.openApp = (app_id)->
		if !Meteor.userId()
			FlowRouter.go "/steedos/sign-in";
			return true
		
		app = db.apps.findOne(app_id)
		if !app
			FlowRouter.go("/")
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

		else if app.internal
			FlowRouter.go(app.url)

		else if app.is_use_iframe
			Steedos.openWindow(Meteor.absoluteUrl("admin/open/by/iframe/" + app._id))

		else if on_click
			# 这里执行的是一个不带参数的闭包函数，用来避免变量污染
			evalFunString = "(function(){#{on_click}})()"
			try
				eval(evalFunString)
			catch e
				# just console the error when catch error
				console.error "catch some error when eval the on_click script for app link:"
				console.error "#{e.message}\r\n#{e.stack}"
		else
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
		unless Steedos.isiOS() or Steedos.isMobile()
			# ios及手机上不需要为zoom放大功能额外计算
			accountZoomValue = Steedos.getAccountZoomValue()
			switch accountZoomValue.name
				when 'large'
					# 测下来这里不需要额外减数
					reValue -= 0
				when 'extra-large'
					reValue -= 25
		if offset
			reValue -= offset
		return reValue + "px";

	Steedos.isiOS = (userAgent, language)->
		DEVICE =
			android: 'android'
			blackberry: 'blackberry'
			desktop: 'desktop'
			ipad: 'ipad'
			iphone: 'iphone'
			ipod: 'ipod'
			mobile: 'mobile'
		browser = {}
		conExp = '(?:[\\/:\\::\\s:;])'
		numExp = '(\\S+[^\\s:;:\\)]|)'
		userAgent = (userAgent or navigator.userAgent).toLowerCase()
		language = language or navigator.language or navigator.browserLanguage
		device = userAgent.match(new RegExp('(android|ipad|iphone|ipod|blackberry)')) or userAgent.match(new RegExp('(mobile)')) or [
		  ''
		  DEVICE.desktop
		]
		browser.device = device[1]
		return browser.device == DEVICE.ipad or browser.device == DEVICE.iphone or browser.device == DEVICE.ipod

	Steedos.getUserOrganizations = (isIncludeParents)->
		userId = Meteor.userId()
		spaceId = Steedos.spaceId()
		space_user = db.space_users.findOne({user:userId,space:spaceId},fields:{organizations:1})
		organizations = space_user?.organizations
		unless organizations
			return []
		if isIncludeParents
			parents = _.flatten db.organizations.find(_id:{$in:organizations}).fetch().getProperty("parents")
			return _.union organizations,parents
		else
			return organizations

if Meteor.isServer
	Steedos.getUserOrganizations = (spaceId,userId,isIncludeParents)->
		space_user = db.space_users.findOne({user:userId,space:spaceId},fields:{organizations:1})
		organizations = space_user?.organizations
		unless organizations
			return []
		if isIncludeParents
			parents = _.flatten db.organizations.find(_id:{$in:organizations}).fetch().getProperty("parents")
			return _.union organizations,parents
		else
			return organizations

if Meteor.isServer
	Cookies = Npm.require("cookies")
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

	Steedos.absoluteUrl = (url)->
		if (Meteor.isCordova)
			return Meteor.absoluteUrl(url);
		else
			if url?.startsWith("/")
				return url
			else if url
				return "/" + url;
			else
				return "/"

#	通过request.headers、cookie 获得有效用户
	Steedos.getAPILoginUser	= (req, res) ->
		cookies = new Cookies(req, res);
		if req.headers
			userId = req.headers["x-user-id"]
			authToken = req.headers["x-auth-token"]

		# then check cookie
		if !userId or !authToken
			userId = cookies.get("X-User-Id")
			authToken = cookies.get("X-Auth-Token")

		if !userId or !authToken
			return false

		if Steedos.checkAuthToken(userId, authToken)
			return db.users.findOne({_id: userId})

		return false

#	检查userId、authToken是否有效
	Steedos.checkAuthToken = (userId, authToken) ->
		if userId and authToken
			hashedToken = Accounts._hashLoginToken(authToken)
			user = Meteor.users.findOne
				_id: userId,
				"services.resume.loginTokens.hashedToken": hashedToken
			if user
				return true
			else
				return false
		return false


if Meteor.isServer
	crypto = Npm.require('crypto');
	Steedos.decrypt = (password, key, iv)->
		try
			key32 = ""
			len = key.length
			if len < 32
				c = ""
				i = 0
				m = 32 - len
				while i < m
					c = " " + c
					i++
				key32 = key + c
			else if len >= 32
				key32 = key.slice(0, 32)

			decipher = crypto.createDecipheriv('aes-256-cbc', new Buffer(key32, 'utf8'), new Buffer(iv, 'utf8'))

			decipherMsg = Buffer.concat([decipher.update(password, 'base64'), decipher.final()])

			password = decipherMsg.toString();
			return password;
		catch e
			return password;

	Steedos.encrypt = (password, key, iv)->
		key32 = ""
		len = key.length
		if len < 32
			c = ""
			i = 0
			m = 32 - len
			while i < m
				c = " " + c
				i++
			key32 = key + c
		else if len >= 32
			key32 = key.slice(0, 32)

		cipher = crypto.createCipheriv('aes-256-cbc', new Buffer(key32, 'utf8'), new Buffer(iv, 'utf8'))

		cipheredMsg = Buffer.concat([cipher.update(new Buffer(password, 'utf8')), cipher.final()])

		password = cipheredMsg.toString('base64')

		return password;



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

if Meteor.isServer
	# 判断是否是节假日
	Steedos.isHoliday = (date)->
		if !date
			date = new Date
		check date, Date
		day = date.getDay()
		# 周六周日为假期
		if day is 6 or day is 0
			return true

		return false
	# 根据传入时间(date)计算几个工作日(days)后的时间,days目前只能是整数
	Steedos.caculateWorkingTime = (date, days)->
		check date, Date
		check days, Number
		param_date = date
		caculateDate = (i, days)->
			if i < days
				param_date = new Date(param_date.getTime() + 24*60*60*1000)
				if !Steedos.isHoliday(param_date)
					i++
				caculateDate(i, days)
			return
		caculateDate(0, days)
		return param_date