Template.accounts_phone.helpers
	currentPhoneNumber: ->
		return Accounts.getPhoneNumber()


Template.accounts_phone.onRendered ->

Template.accounts_phone.events
	'click .btn-send-code': (event,template) ->
		number = $("input.accounts-phone-number").val()
		unless number
			toastr.error t "accounts_phone_enter_phone_number"
			return

		number = "+86 #{number}"

		swal {
			title: t("accounts_phone_swal_confirm_title"),
			text: t("accounts_phone_swal_confirm_text",number),
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
					toastr.error t(error.reason)
					console.log error
					return
				FlowRouter.go "/accounts/setup/phone/#{encodeURIComponent(number)}"
			sweetAlert.close();



