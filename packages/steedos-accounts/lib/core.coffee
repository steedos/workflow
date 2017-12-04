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
	Steedos.isForceBindPhone = false
	if Meteor.settings?.public?.phone?.forceAccountBindPhone
		unless Steedos.isAndroidOrIOS()
			# 只有非手机上才需要提醒手机号未绑定
			Steedos.isForceBindPhone = true
			Meteor.autorun (c)->
				if Meteor.userId() and !Meteor.loggingIn() and Steedos.subsBootstrap.ready()
					c.stop()
					noForceUsers = db.space_settings.findOne({key:"contacts_no_force_phone_users"})?.values
					if noForceUsers and noForceUsers.length
						Steedos.isForceBindPhone = if noForceUsers.indexOf(Meteor.userId()) > -1 then false else true

			Meteor.autorun (c)->
				if Meteor.userId() and !Meteor.loggingIn() and Steedos.subsBootstrap.ready()
					if Accounts.isPhoneVerified()
						c.stop()
						# 关闭sweetAlert弹出框
						$(".accounts-phone-swal-alert .cancel").trigger("click")

			Meteor.autorun (c)->
				# 没有验证手机时，提醒手机号未绑定
				if Meteor.userId() and !Meteor.loggingIn() and Steedos.subsBootstrap.ready()
					c.stop()
					ignoredUsers = Meteor.settings?.public?.phone?.ignoredUsers
					if ignoredUsers and ignoredUsers.contains Meteor.userId()
						return
					routerPath = FlowRouter.current()?.path
					# 当前路由本身就在手机验证路由中则不需要提醒手机号未绑定
					if /^\/accounts\/setup\/phone\b/.test routerPath
						return
					# 登录相关路由不需要提醒手机号未绑定
					if /^\/steedos\//.test routerPath
						return
					if Accounts.isPhoneVerified()
						# 过期后把绑定状态还原为未绑定
						expiredDays = Meteor.settings?.public?.phone?.expiredDays
						if expiredDays
							Accounts.disablePhoneWithoutExpiredDays(expiredDays)
					else
						setupUrl = Steedos.absoluteUrl("accounts/setup/phone")
						if Steedos.isForceBindPhone
							swal {
								customClass : "accounts-phone-swal-alert"
								title: t("accounts_phone_swal_alert"),
								type: "warning",
								confirmButtonText: t('accounts_phone_swal_alert_ok'),
								# cancelButtonText: t('Cancel'),
								showCancelButton: false,
								closeOnConfirm: false
							}, (reason) ->
								# 用户选择取消
								if (reason == false)
									return false;

								Steedos.openWindow(setupUrl,'setup_phone')
						else
							toastr.error(null,t("accounts_phone_toastr_alert"),{
								closeButton: true,
								timeOut: 0,
								extendedTimeOut: 0,
								onclick: ->
									Steedos.openWindow(setupUrl,'setup_phone')
							})