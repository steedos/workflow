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
		number = $(".accounts-phone-number").text()
		swal {
			title: "重新获取验证码",
			text: "我们将发送验证码短信到这个号码：\r\n#{number}",
			confirmButtonColor: "#DD6B55",
			type: "warning",
			confirmButtonText: t('OK'),
			cancelButtonText: t('Cancel'),
			showCancelButton: true,
			closeOnConfirm: false
		}, (reason) ->
			# 用户选择取消
			if (reason == false)
				return false;
			$(document.body).addClass('loading')
			Accounts.requestPhoneVerification number, (error)->
				$(document.body).removeClass('loading')
				if error
					toastr.error error.reason
					console.log error
					return
			sweetAlert.close();


	'click .btn-back': (event,template) ->
		FlowRouter.go "/accounts/setup/phone"

