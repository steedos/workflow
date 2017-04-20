Template.accounts_phone_verify.helpers
	number: ->
		number = FlowRouter.current().path.match(/phone\/(.+)/)?[1]
		return decodeURIComponent number

Template.accounts_phone_verify.onRendered ->

Template.accounts_phone_verify.events
	'click .btn-verify-code': (event,template) ->
		number = $(".accounts-phone-number").text()
		unless number
			toastr.error "手机号无效"
			return
		code = $("input.accounts-phone-code").val()
		unless code
			toastr.error "请输入验证码"
			return

		Accounts.verifyPhone number, code, (error)->
			if error
				toastr.error error.reason
				console.log error
				return
			# FlowRouter.go "/accounts/setup/phone/+86 #{encodeURIComponent(phone)}"

	'click .btn-code-unreceived': (event,template) ->


	'click .btn-back': (event,template) ->
		FlowRouter.go "/accounts/setup/phone"

