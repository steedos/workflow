Template.fsshWebmaill._readmailCount = 0;

readmail  = (uid)->
	console.log('readmail.....');
	if $("#fssh-webmail-iframe")[0].contentWindow.O && $("#fssh-webmail-iframe")[0].contentWindow.O('listmail_1').readMail
		Template.fsshWebmaill._readmailCount = 0;
		$("#fssh-webmail-iframe")[0].contentWindow.O('listmail_1').readMail(uid,'readmail', 'time.1',1)
	else 
		if Template.fsshWebmaill._readmailCount < 200
			Meteor.setTimeout ()->
				readmail(uid)
			, 300
		Template.fsshWebmaill._readmailCount++

Template.fsshWebmaill.onRendered ->
	console.log('fsshWebmaill.onRendered');
	auth = AccountManager.getAuth();
	webmailIframe = $("#fssh-webmail-iframe")
	webmailIframe.hide()
	count = 0
	webmailIframe.load ()->
		count += 1
		console.log('fssh-webmail-iframe load....')
		if webmailIframe.contents().find("#user").length > 0
			webmailIframe.contents().find("#user")?.val(auth.user)
			webmailIframe.contents().find("#password")?.val(auth.pass)
			if count <= 1
				webmailIframe.contents().find(".btn")?.click()
				setTimeout ->
					if webmailIframe.contents().find(".btn")?.length
						webmailIframe.show()
				, 1000
		else
			webmailIframe.show()

			uid = FlowRouter.current()?.queryParams?.uid;
			if uid
				readmail(uid)
				

			webmailIframe.contents().find("#container").on 'click', '.recipients', (event)->
				Modal.show("contacts_modal", {targetId: event.currentTarget.id.substring(event.currentTarget.id.indexOf('_') + 1), target: event.target});

Template.fsshWebmaill.helpers
	webMailURL: ()->
		if !Meteor.settings.public?.fsshWebMailURL
			throw new Meteor.Error('缺少settings配置 public.fsshWebMailURL')
		return Meteor.settings.public?.fsshWebMailURL