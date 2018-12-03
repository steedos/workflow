MimeCodec = require('emailjs-mime-codec');

JsonRoutes.add 'put', '/api/sogo/notify', (req, res, next) ->
	try
		# console.log '/api/sogo/notify==req.body===', req.body
		userMail = req.body.user
		unless userMail
			return

		mailAccount = db.mail_accounts.findOne({email:userMail}, { fields: { owner: 1 } })
		unless mailAccount
			return

		mailBody = req.body
		unless mailBody
			return

		strFroms = mailBody.from.split(" ")
		fromName = strFroms[0]
		fromName = MimeCodec.mimeWordDecode strFroms[0]
		fromEmail = strFroms[1]
		title = ""
		if fromName
			title += fromName
		if fromEmail
			if fromName
				title += " " + fromEmail
			else
				title += fromEmail

		text = MimeCodec.mimeWordDecode mailBody.subject
		unless text
			text = "未命名邮件"

		appName = "workflow"

		notification = new Object
		notification["createdAt"] = new Date
		notification["createdBy"] = '<SERVER>'
		notification["from"] = appName
		notification['title'] = title
		notification['text'] = text

		payload = new Object
		payload["app"] = "sogo"
		payload["event"] = mailBody.event
		payload["folder"] = mailBody.folder
		payload["imap-uidvalidity"] = mailBody["imap-uidvalidity"]
		payload["imap-uid"] = mailBody["imap-uid"]
		payload["host"] = Meteor.absoluteUrl().substr(0, Meteor.absoluteUrl().length-1)
		notification["payload"] = payload

		if req.body.unseen > -1
			notification['badge'] = req.body.unseen
			
		notification['query'] = {userId: mailAccount.owner, appName: appName}
		# console.log '/api/sogo/notify==req.body==send=', notification
		Push.send(notification)
	catch e
		console.error e.stack
	
	res.writeHead(200, {'Content-Type': 'application/xml'})
	res.end('<xml><return_code><![CDATA[SUCCESS]]></return_code></xml>')