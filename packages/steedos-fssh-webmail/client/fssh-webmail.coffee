Template.fsshWebmaill.onRendered ->
	console.log('fsshWebmaill.onRendered');
	auth = AccountManager.getAuth();
	$('#fssh-webmail-iframe').load ()->
		console.log('fssh-webmail-iframe load....')
		if $("#fssh-webmail-iframe").contents().find("#user").length > 0
			$("#fssh-webmail-iframe").contents().find("#user")?.val(auth.user)
			$("#fssh-webmail-iframe").contents().find("#password")?.val(auth.pass)
			$("#fssh-webmail-iframe").contents().find(".btn")?.click()
		else
			$("#fssh-webmail-iframe").contents().find("#container").on 'click', '.recipients', (event)->
				Modal.show("contacts_modal", {targetId: event.currentTarget.id.substring(event.currentTarget.id.indexOf('_') + 1), target: event.target});
