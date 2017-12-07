if Meteor.settings?.public?.phone?.forceAccountBindPhone
	if Meteor.isServer
		Meteor.methods
			checkForceBindPhone: (spaceId) ->
				noForceUsers = db.space_settings.findOne({key:"contacts_no_force_phone_users",space: spaceId})?.values
				if noForceUsers and noForceUsers.length
					return if noForceUsers.indexOf(Meteor.userId()) > -1 then false else true
				return false

	if Meteor.isClient
		Steedos.isForceBindPhone = false
		unless Steedos.isMobile()
			Accounts.onLogin ()->
				if Accounts.isPhoneVerified()
					return
				Meteor.setTimeout ()->
					if Accounts.isPhoneVerified()
						return
					spaceId = Steedos.spaceId()
					unless spaceId
						return
					Meteor.call "checkForceBindPhone", spaceId, (error, results)->
						if error
							toastr.error(t(error.reason))
						else
							Steedos.isForceBindPhone = results
						if Steedos.isForceBindPhone and !Accounts.isPhoneVerified()
							# 未验证手机号时，强行跳转到手机号绑定界面
							setupUrl = "/accounts/setup/phone"
							FlowRouter.go setupUrl

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
							unless Steedos.isForceBindPhone
								toastr.error(null,t("accounts_phone_toastr_alert"),{
									closeButton: true,
									timeOut: 0,
									extendedTimeOut: 0,
									onclick: ->
										Steedos.openWindow(setupUrl,'setup_phone')
								})
				, 5000