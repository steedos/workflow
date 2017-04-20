Template.accounts_phone.helpers

Template.accounts_phone.onRendered ->

Template.accounts_phone.events
	'click .btn-send-code': (event,template) ->
		phone = $("input.accounts-phone").val()
		unless phone
			toastr.error "请输入手机号"
			return
		Accounts.requestPhoneVerification "+86 #{phone}", (error)->
			if error
				toastr.error error.reason
				console.log error
				return
			FlowRouter.go "/accounts/setup/phone/verify"


