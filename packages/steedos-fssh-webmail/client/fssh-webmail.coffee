Template.fsshWebmaill._readmailCount = 0;

Template.fsshWebmaill._overriedDownloadCount = 0;

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

download = ()->
	return false;

overriedDownload = ()->
	console.log('overriedDownload', Template.fsshWebmaill._overriedDownloadCount);
	if $("#fssh-webmail-iframe")[0].contentWindow.download
		if $("#fssh-webmail-iframe")[0].contentWindow.download.toString() != download.toString()
			$("#fssh-webmail-iframe")[0].contentWindow.download = download
	else
		if Template.fsshWebmaill._overriedDownloadCount < 500
			Meteor.setTimeout ()->
				overriedDownload()
			, 300
		Template.fsshWebmaill._overriedDownloadCount++


searchEamil = (url, transferData)->
	contentWindow = $("#fssh-webmail-iframe")[0].contentWindow
	is_report = 0;
	menuId = contentWindow.gModule.getActiveModuleInfo().menuId;
	contentWindow.$.ajax
		url: url + '?q=search.mail.do'
		type: 'post'
		data: transferData + '&is_report=' + is_report
		dataType: 'json'
		cache: false
		success: (resp) ->
			if 0 == resp._login
				alert contentWindow.gCheck.getRestrictMessage(type: 'notLogin')
				contentWindow.gModule.logout()
			else if 0 == resp.res
				if '' != resp.error
					contentWindow.gMessage.showMessageMain resp.error, 'fail'
				else
					contentWindow.gMessage.showMessageMain L('search email error') + contentWindow.gCheck.getRestrictMessage(
						type: 'dataError'
						name: contentWindow.L('search email')), 'fail'
				return false
			data = resp.data
			urlObj = new contentWindow.UrlControl
			urlObj.setUrl '?fid=search&is_report=' + is_report
			urlObj.addReplaceParam 'resid', data
			contentWindow.gModule.loadModule
				moduleName: 'listmail'
				dk: listmail: urlObj.getUrl()
				menuId: menuId
			true
		error: ->
			contentWindow.gMessage.hideMessageTop()
			contentWindow.gMessage.showMessageMain L('search email fail') + contentWindow.gCheck.getRestrictMessage(type: 'systemError'), 'fail'
			false

removeSearchDiv = ()->
	setTimeout ()->
		console.log('removeSearchDiv...');
		$("#steedosSearchDiv", $("#fssh-webmail-iframe").contents().find("#container")).remove()
	, 150

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
			unless auth
				webmailIframe.show()
				return
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

			overriedDownload()

			webmailIframe.contents().find("#container").on 'click', '.recipients', (event)->
				Modal.show("contacts_modal", {targetId: event.currentTarget.id.substring(event.currentTarget.id.indexOf('_') + 1), target: event.target});

			console.log('添加附件事件');
			webmailIframe.contents().find('#container').on 'click', '.fjlist a', (event, t)->
				title = event.target.parentNode.parentNode.childNodes[1].title.toString()
				fileName = title.substr(0 , title.lastIndexOf('(') - 1)
				clickStr = event.target.onclick.toString()
				url = clickStr.substring(clickStr.indexOf('\'') + 3, clickStr.lastIndexOf('\''))
				console.log('url----', url);
				url = new URI(url, event.target.baseURI)
				domainUrl = Meteor.settings.public.fsshWebMailURL
				Steedos.downLoadConfirm(url, fileName, domainUrl)

			#添加搜索函数
			$("#fssh-webmail-iframe")[0].contentWindow.steedosCallSearch = searchEamil

			console.log('添加发件人事件');

			webmailIframe.contents().find('#container').on 'click', '.cur', (event, t)->
				event.stopPropagation();
#				removeSearchDiv()
				searchDiv = document.createElement("div")
				searchDiv.id = 'steedosSearchDiv'

				searchDivA = document.createElement("a")
				searchDivA.textContent = "按发件人搜索"

				firstElementChild = $(event.target.parentNode.firstElementChild)

				searchDiv.style = "width:#{firstElementChild.width() - 44 - 2}px;cursor: pointer;border: 1px solid #828282;border-top:0px;color:#333333;top: #{firstElementChild.offset().top + 16 + 40}px;position: absolute; z-index: 999999999; left: #{firstElementChild.offset().left}px;background:#ffffff;box-shadow: rgba(0, 0, 0, 0.298039) 0px 1px 3px;padding: 11px 22px;font-family: Verdana,Arial,Helvetica,sans-serif;"
				searchDivA.style = "color: #333;"
				searchDiv.appendChild(searchDivA)

				lxrIframe = $("iframe", event.target.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode)[2].contentWindow
				lxrIframe.removeEventListener('blur', removeSearchDiv)
				lxrIframe.addEventListener('blur', removeSearchDiv)
				event.target.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.appendChild(searchDiv)

			webmailIframe.contents().find('#container').on 'click', '#steedosSearchDiv', (event, t)->
				event.stopPropagation();
				s = event.target.parentElement
				if event.target.tagName == 'A'
					s = event.target.parentElement.parentElement

				senderText = $(".cur", s)[0].parentElement.firstElementChild.textContent
				senderMail = senderText.substring(senderText.lastIndexOf("<") + 1, senderText.lastIndexOf(">"))
				console.log('搜索', senderMail)
				$("#fssh-webmail-iframe")[0].contentWindow.steedosCallSearch '/user/',
					"area_subject=&area_content=&area_from=#{encodeURIComponent(senderMail)}&area_to=&area_attach=&folder=0&duration_date=90&is_mail_scope=0"

				removeSearchDiv()

Template.fsshWebmaill.helpers
	webMailURL: ()->
		if !Meteor.settings.public?.fsshWebMailURL
			throw new Meteor.Error('缺少settings配置 public.fsshWebMailURL')
		return Meteor.settings.public?.fsshWebMailURL