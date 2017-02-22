Template.accounts_guide_modal.helpers FSSH.helpers

Template.accounts_guide_modal.onRendered ->

Template.accounts_guide_modal.events
	'click .btn-validate-email': (event,template) ->
		debugger
		spaceId = Session.get "spaceId"
		email = $("#accounts-guide-email-name").val()
		password = $("#accounts-guide-email-password").val()
		unless password
			toastr.error("邮箱密码不能为空")
			return
		Meteor.call 'saveMailAccount', { spaceId, email, password }, (error, is_suc) ->
			if is_suc
				toastr.success "保存成功！"
			else
				console.error error
				toastr.error(error.reason)

	'click .btn-close': (event,template) ->
		Modal.hide "accounts_guide_modal"