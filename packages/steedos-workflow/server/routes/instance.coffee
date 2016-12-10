Cookies = Npm.require("cookies")
#TODO 确认data 中的instance
JsonRoutes.add "get", "/workflow/space/:space/view/readonly/:instance_id", (req, res, next) ->
#	console.log req
	cookies = new Cookies(req, res);

	# first check request body
	if req.body
		userId = req.body["X-User-Id"]
		authToken = req.body["X-Auth-Token"]

	# then check cookie
	if !userId or !authToken
		userId = cookies.get("X-User-Id")
		authToken = cookies.get("X-Auth-Token")

	if !(userId and authToken)
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing X-Auth-Token",
				"instance": "1329598861",
				"success": false
		return;

	#user 、instace、space 校验
	user = db.users.findOne({_id: userId})

	if !user
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing X-User-Id",
				"instance": "1329598861",
				"success": false
		return;

	instanceId = req.params.instance_id

	instance = db.instances.findOne({_id: instanceId});

	if  !instance
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing instance",
				"instance": "1329598861",
				"success": false
		return;

	spaceId = req.params.space

	if instance.space != spaceId
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing space or instance",
				"instance": "1329598861",
				"success": false
		return;

	space = db.spaces.findOne({_id: spaceId});

	if !space
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing space",
				"instance": "1329598861",
				"success": false
		return;

	spaceUser = db.space_users.findOne({user: userId, space: spaceId});

	if !spaceUser
		if !space
			JsonRoutes.sendResult res,
				code: 401,
				data:
					"error": "Validate Request -- Missing sapceUser",
					"instance": "1329598861",
					"success": false
			return;

	#校验user是否对instance有查看权限
	if !WorkflowManager.hasInstancePermissions(user, instance)
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Not Instance Permissions",
				"instance": "1329598861",
				"success": false
		return;

	html = InstanceReadOnlyTemplate.getInstanceHtml(user, space, instance)

	res.statusCode = 200
	res.end(html)





