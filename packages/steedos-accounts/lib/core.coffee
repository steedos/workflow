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
			number?.replace(/^\+86/,"")

if Meteor.isClient
	Meteor.startup ->
		Tracker.autorun (c)->
			if !Meteor.userId() and !Meteor.loggingIn()
				currentPath = FlowRouter.current().path
				if currentPath != undefined and !/^\/steedos\b/.test(currentPath)
					# 没有登录且路由不以/steedos开头则跳转到登录界面
					FlowRouter.go "/steedos/sign-in"

if Meteor.isClient
	if Meteor.settings?.public?.phone?.forceAccountBindPhone
		Meteor.autorun (c)->
			# 没有验证手机时，强行跳转到手机验证路由
			if Meteor.userId() and !Meteor.loggingIn()
				ignoredUsers = Meteor.settings?.public?.phone?.ignoredUsers
				if ignoredUsers and ignoredUsers.contains Meteor.userId()
					return
				routerPath = FlowRouter.current()?.path
				# 当前路由本身就在手机验证路由中则不需要跳转
				if /^\/accounts\/setup\/phone\b/.test routerPath
					return
				# 登录相关路由不需要跳转
				if /^\/steedos\//.test routerPath
					return
				if Accounts.isPhoneVerified()
					# 关闭toastr弹出框
					if Accounts.phoneToastrs?.length
						Accounts.phoneToastrs.forEach (n,i)->
							toastr.clear n

					# 关闭sweetAlert弹出框
					$(".accounts-phone-swal-alert .cancel").trigger("click")

					expiredDays = Meteor.settings?.public?.phone?.expiredDays
					if expiredDays
						Accounts.disablePhoneWithoutExpiredDays(expiredDays)
				else
					setupUrl = Steedos.absoluteUrl("accounts/setup/phone")
					# 这里不可以用Steedos.isMobile()，因为android浏览器上会出现死循环一直刷新界面
					if Steedos.isAndroidOrIOS()
						console.log 'will come soon for setup_phone'
						# Steedos.openWindow(setupUrl,'setup_phone')
					else
						unless Accounts.phoneToastrs
							Accounts.phoneToastrs = []
						if Accounts.phoneToastrs.length
							Accounts.phoneToastrs.forEach (n,i)->
								toastr.clear n
							Accounts.phoneToastrs = []

						Accounts.phoneToastrs.push toastr.error(null,t("accounts_phone_toastr_alert"),{
							closeButton: true,
							timeOut: 0,
							extendedTimeOut: 0,
							onclick: ->
								Steedos.openWindow(setupUrl,'setup_phone')
						})
						
						swal {
							customClass : "accounts-phone-swal-alert"
							title: t("accounts_phone_swal_alert"),
							type: "warning",
							confirmButtonText: t('accounts_phone_swal_alert_ok'),
							cancelButtonText: t('Cancel'),
							showCancelButton: true,
							closeOnConfirm: false
						}, (reason) ->
							# 用户选择取消
							if reason == false
								return false

							Steedos.openWindow(setupUrl,'setup_phone')
							sweetAlert.close()