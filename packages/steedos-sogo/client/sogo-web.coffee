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
	unless Steedos.isNode()
		return
	auth = AccountManager.getAuth();
	webIframe = $("#sogo-web-iframe")
	webIframe.hide()
	count = 0
	webIframe.load ()->
		if count == 0 and Steedos.isNode()
			chrome.cookies.remove({name:'0xHIGHFLYxSOGo',url:'https://mail.steedos.cn/SOGo/'})
			chrome.cookies.remove({name:'XSRF-TOKEN',url:'https://mail.steedos.cn/SOGo/'})
		count += 1
		console.log('sogo-web-iframe load....count...', count)
		loginForm = webIframe.contents().find("form[name=loginForm]")
		if loginForm.length > 0
			unless auth
				webIframe.show()
				return
			if count <= 2
				webIframe.hide()
			loginController = webIframe[0].contentWindow.loginController
			if loginController
				loginController.creds.username = auth.user
				loginController.creds.password = auth.pass
				loginController.creds.language = "ChineseChina"
				if count <= 2
					loginController.login()
					setTimeout ->
						if webIframe.contents().find("form[name=loginForm]")?.length
							webIframe.show()
					, 1500
			else
				webIframe.show()
				console.error "未找到sogo web的loginController，请确认sogo版本是否正确！"
		else
			webIframe[0].contentWindow.isSteedosNode = Steedos.isNode()
			webIframe.show()
			# uid = FlowRouter.current()?.queryParams?.uid;
			# if uid
			# 	readmail(uid)
			webIframe.contents().find("body").on 'click', '.btn-open-contacts', (event)->
				Modal.show("contacts_modal", { target: event.target });

Template.sogoWeb.helpers
	webURL: ()->
		if !Meteor.settings.public?.sogoWebURL
			throw new Meteor.Error('缺少settings配置 public.sogoWebURL')
		return Meteor.settings.public?.sogoWebURL