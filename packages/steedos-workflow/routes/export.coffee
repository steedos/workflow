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
				"success": false
			})
			return ;

		formId = req.query?.formId;

		form = db.forms.findOne({_id: formId}, {fields: {space: 1}})

		user_spaces = db.space_users.find({user: userId}).fetch().getProperty("space")

		if _.isEmpty(form)
			res.writeHead(401);
			res.end JSON.stringify({
				"error": "Validate Request -- Invalid formId",
				"success": false
			})
			return ;
		else
			if _.indexOf(user_spaces,form.space) < 0
				res.writeHead(401);
				res.end JSON.stringify({
					"error": "Validate Request -- No permission",
					"success": false
				})

#		TODO 流程权限判断

		data = steedosExport.form(formId);

		if _.isEmpty(data)
			fileName = 'null'
		else
			fileName = data.name

		res.setHeader('Content-type', 'application/x-msdownload');
		res.setHeader('Content-Disposition', 'attachment;filename='+encodeURI(fileName)+'.json');
		res.end(JSON.stringify(data))