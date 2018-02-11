Cookies = Npm.require("cookies")

JsonRoutes.add "post", "/api/workflow/import/form", (req, res, next) ->
	cookies = new Cookies( req, res );

	msg = ""
	# first check request body
	if req.body
		uid = req.body["X-User-Id"]
		authToken = req.body["X-Auth-Token"]

	# then check cookie
	if !uid or !authToken
		uid = cookies.get("X-User-Id")
		authToken = cookies.get("X-Auth-Token")

	if !(uid and authToken)
		res.writeHead(401);
		res.end JSON.stringify({
			"error": "Validate Request -- Missing X-Auth-Token",
			"success": false
		})
		return ;

	spaceId = req.query?.space;

	space = db.spaces.findOne({_id: spaceId})

	if !space?.is_paid
		JsonRoutes.sendResult res,
			code: 404,
			data:
				"error": "Validate Request -- Non-paid space.",
				"success": false
		return;

#	是否工作区管理员
	if !Steedos.isSpaceAdmin(spaceId, uid)
		res.writeHead(401);
		res.end JSON.stringify({
			"error": "Validate Request -- No permission",
			"success": false
		})

		return

	try
		JsonRoutes.parseFiles req, res, ()->
			try
				if req.files and req.files[0]

					jsonData = req.files[0].data.toString("utf-8")
					try
						form = JSON.parse(jsonData)
						steedosImport.workflow(uid, spaceId, form, false);
						res.statusCode = 200;
					catch e
						console.error e
						msg = e
						res.statusCode = 500;
					res.end(msg)
					return
				else
					msg = "无效的附件"
					res.statusCode = 500;
					res.end(msg);
			catch e1
				msg = "无效的JSON文件"
				res.statusCode = 500;
				res.end(msg);
	catch e
		console.log(e)

