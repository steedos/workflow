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
				if Accounts.isPhoneVerified()
					expiredDays = Meteor.settings?.public?.phone?.expiredDays
					if expiredDays
						Accounts.disablePhoneWithoutExpiredDays(expiredDays)
				else
					Steedos.openWindow(Steedos.absoluteUrl("/accounts/setup/phone"),'setup_phone')
