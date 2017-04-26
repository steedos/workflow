Template.accounts_phone_verify.helpers
	number: ->
		number = FlowRouter.current().path.match(/phone\/(.+)/)?[1]
		return decodeURIComponent number

Template.accounts_phone_verify.onRendered ->

Template.accounts_phone_verify.events
	'click .btn-verify-code': (event,template) ->
		number = $(".accounts-phone-number").text()
		unless number
			toastr.error t "accounts_phone_invalid"
			return
		code = $("input.accounts-phone-code").val()
		unless code
			toastr.error t "accounts_phone_enter_phone_code"
			return

		$(document.body).addClass('loading')
		Accounts.updatePhone number, (error, is_suc) ->
			if is_suc
				Accounts.verifyPhone number, code, (error) ->
					$(document.body).removeClass('loading')
					if error
						toastr.error t error.reason
						console.error error
						return
					toastr.success t "accounts_phone_verify_suc"
					FlowRouter.go "/admin"
			else
				$(document.body).removeClass('loading')
				toastr.error t error.reason
				console.error error


	'click .btn-code-unreceived': (event,template) ->
		number = $(".accounts-phone-number").text()
		swal {
			title: t("accounts_phone_swal_unreceived_title"),
			text: t("accounts_phone_swal_unreceived_text",number),
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
					toastr.error t error.reason
					console.error error
					return
			sweetAlert.close();


	'click .btn-back': (event,template) ->
		FlowRouter.go "/accounts/setup/phone"

