Template.accounts_phone.helpers
	currentPhoneNumber: ->
		return Accounts.getPhoneNumber()


Template.accounts_phone.onRendered ->

Template.accounts_phone.events
	'click .btn-send-code': (event,template) ->
		number = $("input.accounts-phone-number").val()
		unless number
			toastr.error "请输入手机号"
			return

		number = "+86 #{number}"

		swal {
			title: "确认手机号码",
			text: "我们将发送验证码短信到这个号码：\r\n#{number}",
			confirmButtonColor: "#DD6B55",
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
				FlowRouter.go "/accounts/setup/phone/#{encodeURIComponent(number)}"
			sweetAlert.close();


