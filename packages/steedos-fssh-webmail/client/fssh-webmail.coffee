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

			overriedDownload()

			webmailIframe.contents().find("#container").on 'click', '.recipients', (event)->
				Modal.show("contacts_modal", {targetId: event.currentTarget.id.substring(event.currentTarget.id.indexOf('_') + 1), target: event.target});

			console.log('添加附件事件');
			webmailIframe.contents().find('#container').on 'click', '.fjlist a', (event, t)->


#				event.preventDefault();
#				event.stopPropagation();
#				event.stopImmediatePropagation()
				console.log('fujian......');
				console.log(event, t);
				title = event.target.parentNode.parentNode.childNodes[1].title.toString()
				fileName = title.substr(0 , title.lastIndexOf('(') - 1)
				clickStr = event.target.onclick.toString()
				url = clickStr.substring(clickStr.indexOf('\'') + 3, clickStr.lastIndexOf('\''))
				console.log('url----', url);
				url = new URI(url, event.target.baseURI)
				swal({
					title: fileName,
					type: "info",
					showCancelButton: true,
					cancelButtonText: "另存为",
					confirmButtonText: "打开",
					closeOnConfirm: false
				},(reason) ->
					if (reason == false)
						console.log('点击了另存为');
						chrome.downloads.download {url: url.toString()}
					else
						swal({
							title: "数据读取中，请稍后！",
							text: "数据读取完成后，将自动打开"
							showConfirmButton: false
						});
						Steedos.downLoadFile url, fileName, ()->
							sweetAlert.close();
				)

Template.fsshWebmaill.helpers
	webMailURL: ()->
		if !Meteor.settings.public?.fsshWebMailURL
			throw new Meteor.Error('缺少settings配置 public.fsshWebMailURL')
		return Meteor.settings.public?.fsshWebMailURL