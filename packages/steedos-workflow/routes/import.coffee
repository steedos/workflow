JsonRoutes.add "post", "/api/workflow/form/import", (req, res, next) ->
#	return message
	msg = ""
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
	uid = userId

#	TODO校验用户是否有流程新建权限
	spaceId = '52ba669333490464b4000065'
	#	安全校验
	JsonRoutes.parseFiles req, res, ()->
		if req.files and req.files[0]

			console.log req.files[0]

			jsonData = req.files[0].data.toString("utf-8")
			console.log jsonData
			try
				steedosImport.workflow(uid, spaceId, jsonData);
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

