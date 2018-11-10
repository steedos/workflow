Template.fsshWebmaill.onRendered ->
	console.log('fsshWebmaill.onRendered');
	auth = AccountManager.getAuth();
	ifr = $("#fssh-webmail-iframe")
	ifr.hide()
	count = 0
	ifr.load ()->
		count += 1
		console.log('fssh-webmail-iframe load....')
		if ifr.contents().find("#user").length > 0
			ifr.contents().find("#user")?.val(auth.user)
			ifr.contents().find("#password")?.val(auth.pass)
			if count <= 1
				ifr.contents().find(".btn")?.click()
				setTimeout ->
					if ifr.contents().find(".btn")?.length
						ifr.show()
				, 1000
		else
			ifr.show()
			ifr.contents().find("#container").on 'click', '.recipients', (event)->
				Modal.show("contacts_modal", {targetId: event.currentTarget.id.substring(event.currentTarget.id.indexOf('_') + 1), target: event.target});
