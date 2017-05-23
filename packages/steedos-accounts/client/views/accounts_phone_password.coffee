Template.accounts_phone_password.helpers
	number: ->
		isPhoneVerified = Accounts.isPhoneVerified()
		if isPhoneVerified
			return Accounts.getPhoneNumber(true)
		else
			return ""
	title: ->
		return t "accounts_phone_password_title"

Template.accounts_phone_password.onRendered ->
	Meteor.autorun (c)->
		number = Accounts.getPhoneNumber(true)
		if number
			c.stop()
			isPhoneVerified = Accounts.isPhoneVerified()
			if isPhoneVerified
				console.log "here will send sms code for number:#{number}"
				# Accounts.requestPhoneVerification number, (error)->
				# 	if error
				# 		toastr.error t error.reason
				# 		console.error error
				# 		return

Template.accounts_phone_password.events
	'click .btn-verify-code': (event,template) ->
		number = $(".accounts-phone-number").text()
		unless number
			toastr.error t "accounts_phone_invalid"
			return
		code = $("input.accounts-phone-code").val()
		unless code
			toastr.error t "accounts_phone_enter_phone_code"
			return
		password = $(".accounts-password").val()
		unless password
			toastr.error t "accounts_phone_password_invalid"
			return
		password2 = $(".accounts-password-again").val()
		unless password2 is password
			toastr.error t "accounts_phone_password_again_invalid"
			return

		$(document.body).addClass('loading')
		Accounts.verifyPhone number, code, password, (error) ->
			$(document.body).removeClass('loading')
			if error
				toastr.error t error.reason
				console.error error
				return
			if window.name == "setup_phone"
				toastr.success t "accounts_phone_password_suc_wait"
				setTimeout ->
					window.close()
				,5000
			else
				toastr.success t "accounts_phone_password_suc"
				FlowRouter.go "/admin"


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


