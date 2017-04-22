_.extend Accounts,
	updatePhone: (number,callback)->
		if Meteor.isServer
			Meteor.call 'updatePhone', { number }
		if Meteor.isClient
			Meteor.call 'updatePhone', { number }, callback
	getPhoneNumber: (isIncludePrefix) ->
		number = Accounts.user()?.phone?.number
		if isIncludePrefix
			return number
		else
			number?.replace(/^\+86/,"")

if Meteor.isClient
	if Meteor.settings?.public?.phone?.forceAccountBindPhone
		Meteor.autorun ->
			# 没有验证手机时，强行跳转到手机验证路由
			if Meteor.userId() and !Meteor.loggingIn()
				routerPath = Session.get("router-path")
				# 当前路由本身就在手机验证路由中则不需要跳转
				if /^\/accounts\/setup\/phone\b/.test routerPath
					return
				# 登录相关路由不需要跳转
				if /^\/steedos\//.test routerPath
					return
				unless Accounts.isPhoneVerified()
					FlowRouter.go("/accounts/setup/phone")