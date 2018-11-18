Template.sogoWeb._readmailCount = 0;

readmail  = (uid)->
	console.log('readmail.....');
	if $("#sogo-web-iframe")[0].contentWindow.O && $("#sogo-web-iframe")[0].contentWindow.O('listmail_1').readMail
		Template.sogoWeb._readmailCount = 0;
		$("#sogo-web-iframe")[0].contentWindow.O('listmail_1').readMail(uid,'readmail', 'time.1',1)
	else 
		if Template.sogoWeb._readmailCount < 200
			Meteor.setTimeout ()->
				readmail(uid)
			, 300
		Template.sogoWeb._readmailCount++

Template.sogoWeb.onRendered ->
	console.log('sogoWeb.onRendered');
	auth = AccountManager.getAuth();
	webIframe = $("#sogo-web-iframe")
	webIframe.hide()
	count = 0
	webIframe.load ()->
		count += 1
		console.log('sogo-web-iframe load....')
		loginForm = webIframe.contents().find("form[name=loginForm]")
		if loginForm.length > 0
			# loginForm.find("input[ng-model*='username']")?.val(auth.user)
			# loginForm.find("input[ng-model*='password']")?.val(auth.pass)
			loginController = webIframe[0].contentWindow.loginController
			if loginController
				loginController.creds.username = "postmaster@czpmail.com"
				loginController.creds.password = "adminhotoa"
				loginController.creds.language = "ChineseChina"
				if count <= 1
					loginController.login()
					setTimeout ->
						if webIframe.contents().find("form[name=loginForm]")?.length
							webIframe.show()
					, 1500
			else
				console.error "未找到sogo web的loginController，请确认sogo版本是否正确！"
		else
			webIframe[0].contentWindow.isSteedosNode = Steedos.isNode()
			webIframe.show()
			# uid = FlowRouter.current()?.queryParams?.uid;
			# if uid
			# 	readmail(uid)
			webIframe.contents().find("body").on 'click', '.btn-open-contacts', (event)->
				Modal.show("contacts_modal", {targetId: event.currentTarget.id.substring(event.currentTarget.id.indexOf('_') + 1), target: event.target});

Template.sogoWeb.helpers
	webURL: ()->
		if !Meteor.settings.public?.sogoWebURL
			throw new Meteor.Error('缺少settings配置 public.sogoWebURL')
		return Meteor.settings.public?.sogoWebURL