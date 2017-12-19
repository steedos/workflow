@Setup = {}
Steedos.uri = new URI(Meteor.absoluteUrl());

_.extend Accounts,
	updatePhone: (number,callback)->
		if Meteor.isServer
			Meteor.call 'updatePhone', { number }
		if Meteor.isClient
			Meteor.call 'updatePhone', { number }, callback,
	disablePhoneWithoutExpiredDays: (expiredDays,callback)->
		if Meteor.isServer
			Meteor.call 'disablePhoneWithoutExpiredDays', expiredDays
		if Meteor.isClient
			Meteor.call 'disablePhoneWithoutExpiredDays', expiredDays, callback
	getPhoneNumber: (isIncludePrefix, userId) ->
		if Meteor.isClient
			phone = Accounts.user()?.phone
		else
			phone = db.user.findOne(userId)?.phone
		unless phone
			return ""
		if isIncludePrefix
			return phone.number
		else
			unless phone.mobile
				# 如果数据库中不存在mobile值，则用算法计算出不带前缀的手机号
				return E164.getPhoneNumberWithoutPrefix phone.number
			return phone.mobile
	getPhonePrefix: (userId) ->
		# 返回当前用户手机号前缀，如果找不到则返回默认的"+86"
		if Meteor.isClient
			phone = Accounts.user()?.phone
		else
			phone = db.user.findOne(userId)?.phone
		unless phone
			return "+86"
		if phone.mobile
			prefix = phone.number.replace phone.mobile, ""
		else
			# 如果数据库中不存在mobile值，则用算法计算出手机号前缀
			prefix = "+#{E164.findPhoneCountryCode(phone.number)}"
		return if prefix then prefix else "+86"

if Meteor.isClient
	Meteor.startup ->
		Tracker.autorun (c)->
			if !Meteor.userId() and !Meteor.loggingIn()
				currentPath = FlowRouter.current().path
				if currentPath != undefined and !/^\/steedos\b/.test(currentPath)
					# 没有登录且路由不以/steedos开头则跳转到登录界面
					FlowRouter.go "/steedos/sign-in"
