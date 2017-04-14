Cookies = Npm.require("cookies")
#TODO 确认data 中的instance
JsonRoutes.add "get", "/workflow/space/:space/view/readonly/:instance_id", (req, res, next) ->
	cookies = new Cookies(req, res);

	if req.headers
		userId = req.headers["x-user-id"]
		authToken = req.headers["x-auth-token"]

	# then check cookie
	if !userId or !authToken
		userId = cookies.get("X-User-Id")
		authToken = cookies.get("X-Auth-Token")

	if !(userId and authToken)
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing X-Auth-Token",
				"success": false
		return;

	#user 、instace、space 校验
	user = db.users.findOne({_id: userId})

	if !user
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing X-User-Id",
				"success": false
		return;

	instanceId = req.params.instance_id

	instance = db.instances.findOne({_id: instanceId});

	if  !instance
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing instance",
				"success": false
		return;

	spaceId = req.params.space

	if instance.space != spaceId
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing space or instance",
				"success": false
		return;

	space = db.spaces.findOne({_id: spaceId});

	if !space
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing space",
				"success": false
		return;

	spaceUser = db.space_users.findOne({user: userId, space: spaceId});

	if !spaceUser
		if !space
			JsonRoutes.sendResult res,
				code: 401,
				data:
					"error": "Validate Request -- Missing sapceUser",
					"success": false
			return;

	#校验user是否对instance有查看权限
	if !WorkflowManager.hasInstancePermissions(user, instance)
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Not Instance Permissions",
				"success": false
		return;

	html = InstanceReadOnlyTemplate.getInstanceHtml(user, space, instance)

	res.statusCode = 200
	res.end(html)


JsonRoutes.add "get", "/api/workflow/instances", (req, res, next) ->
	cookies = new Cookies(req, res);

	if req.headers
		userId = req.headers["x-user-id"]
		authToken = req.headers["x-auth-token"]

	# then check cookie
	if !userId or !authToken
		userId = cookies.get("X-User-Id")
		authToken = cookies.get("X-Auth-Token")

	if !(userId and authToken)
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing X-Auth-Token",
				"success": false
		return;

	#user 、instace、space 校验
	user = db.users.findOne({_id: userId})

	if !user
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing X-User-Id",
				"success": false
		return;

	spaceId = req.headers["x-space-id"]

	if not spaceId
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing X-Space-Id",
				"success": false
		return;

	console.log user.email

	#	是否工作区管理员
	if !Steedos.isSpaceAdmin(spaceId, userId)
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- No permission",
				"success": false
		return;

	forms = req.query?.forms

	if !forms
		JsonRoutes.sendResult res,
			code: 400,
			data:
				"error": "Validate Request -- Missing forms",
				"success": false
		return;

	query = {}

	ret_sync_token = new Date().getTime()

	forms = forms.split(",")

	query.form = {$in: forms}

	query.space = spaceId

	if req.query?.sync_token
		sync_token = new Date(Number(req.query.sync_token))
		query.modified = {$gt: sync_token}

	if req.query?.state
		query.state = {$in: req.query.state.split(",")}
	else
		query.state = "completed"

	instances = db.instances.find query, {fields: {inbox_uers: 0, cc_users: 0, outbox_users: 0, traces: 0}}

	JsonRoutes.sendResult res,
			code: 200,
			data:
				"status": "success",
				"sync_token": ret_sync_token
				"data": instances.fetch()
	return;
