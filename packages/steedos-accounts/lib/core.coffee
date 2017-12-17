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
	getPhoneNumber: (isIncludePrefix) ->
		number = Accounts.user()?.phone?.number
		if isIncludePrefix
			return number
		else
			return E164.getPhoneNumberWithoutPrefix number

if Meteor.isClient
	Meteor.startup ->
		Tracker.autorun (c)->
			if !Meteor.userId() and !Meteor.loggingIn()
				currentPath = FlowRouter.current().path
				if currentPath != undefined and !/^\/steedos\b/.test(currentPath)
					# 没有登录且路由不以/steedos开头则跳转到登录界面
					FlowRouter.go "/steedos/sign-in"
