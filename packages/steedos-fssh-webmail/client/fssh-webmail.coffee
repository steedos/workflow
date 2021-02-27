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

download = (url, a)->
	if url && (url.indexOf("q=compose.output&action=mail.attach.compress") > -1 || url.indexOf("is_report=0") < 0)
		$("#fssh-webmail-iframe")[0].contentWindow.downloadCompress(url, a)
	return false;

overriedDownload = ()->
	console.log('overriedDownload', Template.fsshWebmaill._overriedDownloadCount);
	if $("#fssh-webmail-iframe")[0].contentWindow.download
		if $("#fssh-webmail-iframe")[0].contentWindow.download.toString() != download.toString()
			$("#fssh-webmail-iframe")[0].contentWindow.downloadCompress = $("#fssh-webmail-iframe")[0].contentWindow.download
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

parseQueryString = (url) ->
	obj = {}
	start = url.indexOf('?') + 1
	str = url.substr(start)
	arr = str.split('&')
	i = 0
	while i < arr.length
		arr2 = arr[i].split('=')
		obj[arr2[0]] = arr2[1]
		i++
	obj

webmailIframeReload = (iframeId) ->
	webmailIframe = $("#{iframeId}");
	if !Meteor.settings.public?.fsshBaseMail
		throw new Meteor.Error('缺少settings配置 public.fsshBaseMail')
	
	url = Meteor.settings.public?.fsshBaseMail;
	if webmailIframe
		setTimeout ()->
			document.getElementById(iframeId).src=url;
		,3600000


Template.fsshWebmaill.onRendered ->
	console.log('fsshWebmaill.onRendered');
	# debugger;
	auth = AccountManager.getAuth();
	webmailIframe = $("#fssh-webmail-iframe")
	webmailIframe.hide()
	count = 0
	webmailIframeHidden = $("#fssh-webmail-iframe-hidden")
	webmailIframe.load ()->
		count += 1
		console.log('fssh-webmail-iframe load....')
		# debugger;
		if webmailIframe.contents().find("#user1").length > 0
			unless auth
				webmailIframe.show()
				return
			# console.log("auth.user1: ",auth.user.split('@')[0]);
			# console.log("auth.pass1: ",auth.pass);
			webmailIframe.contents().find("#user1")?.val(auth.user.split('@')[0])
			webmailIframe.contents().find("#common_password")?.val(auth.pass)
			if count <= 1
				webmailIframe.contents().find(".btn")?.click()
				setTimeout ->
					if webmailIframe.contents().find(".btn")?.length
						webmailIframe.show()
				, 1000
		else
			webmailIframe.show()

			style = document.createElement('style');
			style.type = 'text/css';
			style.innerHTML="#steedosSearchDiv a{color:#333} #steedosSearchDiv a:hover{ background: #d54a4a; color: #fff;}";
			webmailIframe.contents().find("HEAD")[0].appendChild(style);

			uid = FlowRouter.current()?.queryParams?.uid;
			if uid
				readmail(uid)

			overriedDownload()

			webmailIframe.contents().find("#container").on 'click', '.recipients', (event)->
				try
					setTimeout(
						()->
							$($('.address_dialog_btn',$("#fssh-webmail-iframe").contents().find(".address_dialog_main"))[3]).trigger('click');
						,100);
				catch err
					console.error(err);
				Modal.show("contacts_modal", {targetId: event.currentTarget.id.substring(event.currentTarget.id.indexOf('_') + 1), target: event.target});
				return false;
				
				

			console.log('添加附件事件');
			webmailIframe.contents().find('#container').on 'click', '.fjlist a', (event, t)->
				title = event.target.parentNode.parentNode.childNodes[1].title.toString()
				fileName = title.substr(0 , title.lastIndexOf('(') - 1)
				clickStr = event.target.onclick.toString()
				url = clickStr.substring(clickStr.indexOf('\'') + 3, clickStr.lastIndexOf('\''))
				console.log('url----', url);
				mid = parseQueryString(url)?.mid
				url = new URI(url, event.target.baseURI)
				domainUrl = Meteor.settings.public.fsshWebMailURL
				Steedos.downLoadConfirm(url, fileName, domainUrl, mid)

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

				searchDiv.style = "width:#{firstElementChild.width() - 2}px;cursor: pointer;border: 1px solid #828282;border-top:0px;color:#333333;top: #{firstElementChild.offset().top + 16 + 40}px;position: absolute; z-index: 999999999; left: #{firstElementChild.offset().left}px;background:#ffffff;box-shadow: rgba(0, 0, 0, 0.298039) 0px 1px 3px;padding: 6px 0px;font-family: Verdana,Arial,Helvetica,sans-serif;"
				searchDivA.style = "white-space: nowrap;display: block;height: 26px;line-height: 26px;text-decoration: none;padding: 0 22px;font-size: 12px;"
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
	webmailIframeHidden.load () ->
		webmailIframeReload('fssh-webmail-iframe-hidden');
		console.log('------------fssh-webmail-iframe-hidden load----------------');

Template.fsshWebmaill.helpers
	webMailURL: ()->
		if !Meteor.settings.public?.fsshWebMailURL
			throw new Meteor.Error('缺少settings配置 public.fsshWebMailURL')
		return Meteor.settings.public?.fsshWebMailURL
	
	webBaseURL: ()->
		if !Meteor.settings.public?.fsshBaseMail
			throw new Meteor.Error('缺少settings配置 public.fsshBaseMail')
		return Meteor.settings.public?.fsshBaseMail