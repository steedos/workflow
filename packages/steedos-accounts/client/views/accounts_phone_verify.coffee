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

		$(document.body).addClass('loading')
		Accounts.updatePhone number, (error, is_suc) ->
			if is_suc
				Accounts.verifyPhone number, code, (error) ->
					$(document.body).removeClass('loading')
					if error
						toastr.error error.reason
						console.log error
						return
					toastr.success "手机号验证通过！"
					FlowRouter.go "/admin"
			else
				$(document.body).removeClass('loading')
				toastr.error error.reason
				console.log error


	'click .btn-code-unreceived': (event,template) ->


	'click .btn-back': (event,template) ->
		FlowRouter.go "/accounts/setup/phone"

