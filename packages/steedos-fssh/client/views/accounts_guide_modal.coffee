Template.accounts_guide_modal.helpers FSSH.helpers

Template.accounts_guide_modal.onRendered ->

Template.accounts_guide_modal.events
	'click .btn-validate': (event,template) ->
		debugger
		spaceId = Session.get "spaceId"
		email = $("#accounts-guide-email").val()
		password = $("#accounts-guide-password").val()
		Meteor.call 'saveMailAccount', { spaceId, email, password }, (error, is_suc) ->
			if is_suc
				toastr.success "保存成功！"
			else
				console.error error
				toastr.error(error.reason)