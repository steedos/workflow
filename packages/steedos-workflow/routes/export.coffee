Cookies = Npm.require("cookies")

Meteor.startup ->
	WebApp.connectHandlers.use "/api/workflow/form/export", (req, res, next)->
		cookies = new Cookies( req, res );
#		TODO 权限验证
		# first check request body
		if req.body
			userId = req.body["X-User-Id"]
			authToken = req.body["X-Auth-Token"]

		# then check cookie
		if !userId or !authToken
			userId = cookies.get("X-User-Id")
			authToken = cookies.get("X-Auth-Token")

		if !(userId and authToken)
			res.writeHead(401);
			res.end JSON.stringify({
				"error": "Validate Request -- Missing X-Auth-Token",
				"instance": "1329598861",
				"success": false
			})
			return ;

		formId = req.query?.formId;

		data = steedosExport.form(formId);

		if _.isEmpty(data)
			fileName = 'null'
		else
			fileName = data.name

		res.setHeader('Content-type', 'application/x-msdownload');
		res.setHeader('Content-Disposition', 'attachment;filename='+encodeURI(fileName)+'.json');
		res.end(JSON.stringify(data))