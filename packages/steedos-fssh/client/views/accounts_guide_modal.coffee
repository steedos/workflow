Template.accounts_guide_modal.helpers FSSH.helpers

Template.accounts_guide_modal.onRendered ->

Template.accounts_guide_modal.events
	'click .btn-validate-email': (event,template) ->
		spaceId = Session.get "spaceId"
		email = $("#accounts-guide-email-name").val()
		password = $("#accounts-guide-email-password").val()
		unless password
			toastr.error("邮箱密码不能为空")
			return

		$(document.body).addClass('loading')
		FSSH.checkAccount {user: email,pass: password}, (error, is_suc)->
			if is_suc
				Meteor.call 'saveMailAccount', { spaceId, email, password }, (error, is_suc) ->
					$(document.body).removeClass('loading')
					if is_suc
						toastr.success "验证通过，账户密码已同步！"
					else
						console.error error
						toastr.error(error.reason)
			else
				$(document.body).removeClass('loading')
				console.error error
				toastr.error(error.reason)

	'click .btn-save-ptr': (event,template) ->
		spaceId = Session.get "spaceId"
		auth_name = "ptr"
		login_name = $("#accounts-guide-ptr-name").val()
		login_password = $("#accounts-guide-ptr-password").val()
		unless login_name
			toastr.error("PTR域账户名称不能为空")
			return
		unless login_password
			toastr.error("PTR域账户密码不能为空")
			return
		$(document.body).addClass('loading')
		Meteor.call 'saveAuthUser', { spaceId, auth_name, login_name, login_password }, (error, is_suc) ->
			$(document.body).removeClass('loading')
			if is_suc
				toastr.success "保存成功！"
			else
				console.error error
				toastr.error(error.reason)

	'click .btn-save-cnpc': (event,template) ->
		spaceId = Session.get "spaceId"
		auth_name = "cnpc"
		login_name = $("#accounts-guide-cnpc-name").val()
		login_password = $("#accounts-guide-cnpc-password").val()
		unless login_name
			toastr.error("CNPC域账户名称不能为空")
			return
		unless login_password
			toastr.error("CNPC域账户密码不能为空")
			return
		$(document.body).addClass('loading')
		Meteor.call 'saveAuthUser', { spaceId, auth_name, login_name, login_password }, (error, is_suc) ->
			$(document.body).removeClass('loading')
			if is_suc
				toastr.success "保存成功！"
			else
				console.error error
				toastr.error(error.reason)

	'click .btn-save': (event,template) ->
		currentUserId = Meteor.userId()
		mail_account = db.mail_accounts.findOne({owner:currentUserId})
		if mail_account
			spaceId = Session.get "spaceId"
			auth_users = []
			auth_name = "ptr"
			login_name = $("#accounts-guide-ptr-name").val()
			login_password = $("#accounts-guide-ptr-password").val()
			if login_name and login_password
				auth_users.push { spaceId, auth_name, login_name, login_password }
			auth_name = "cnpc"
			login_name = $("#accounts-guide-cnpc-name").val()
			login_password = $("#accounts-guide-cnpc-password").val()
			if login_name and login_password
				auth_users.push { spaceId, auth_name, login_name, login_password }
			if auth_users.length
				Meteor.call 'saveAuthUsers', auth_users, (error, is_suc) ->
					$(document.body).removeClass('loading')
					if is_suc
						Modal.hide "accounts_guide_modal"
						toastr.success "保存成功！"
					else
						console.error error
						toastr.error(error.reason)
			else
				Modal.hide "accounts_guide_modal"
		else
			toastr.error("您的账户没有通过验证！")

	'click .btn-cancel': (event,template) ->
		currentUserId = Meteor.userId()
		mail_account = db.mail_accounts.findOne({owner:currentUserId})
		unless mail_account
			toastr.error("您的账户没有通过验证！")
			return
		Modal.hide "accounts_guide_modal"


