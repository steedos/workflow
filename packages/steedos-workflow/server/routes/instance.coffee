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

	user = Steedos.getAPILoginUser(req, res)

	if !user
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing X-Auth-Token,X-User-Id",
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

	flowId = req.query?.flowId

	if !flowId
		JsonRoutes.sendResult res,
			code: 400,
			data:
				"error": "Validate Request -- Missing flowId",
				"success": false
		return;

	query = {}

	ret_sync_token = new Date().getTime()

	flowIds = flowId.split(",")


	flows = db.flows.find({_id: {$in: flowIds}}).fetch()

	i = 0
	while i < flows.length
		f = flows[i]
		spaceUser = db.space_users.findOne({space: f.space, user: user._id})
		if !spaceUser
			JsonRoutes.sendResult res,
				code: 401,
				data:
					"error": "Validate Request -- No permission, flow is #{f._id}",
					"success": false
			return;
		else

	#	是否工作区管理员
		if !Steedos.isSpaceAdmin(spaceId, user._id)
			spaceUserOrganizations = db.organizations.find({
				_id: {
					$in: spaceUser.organizations
				}
			}).fetch();

			if !WorkflowManager.canMonitor(f, spaceUser, spaceUserOrganizations) && !WorkflowManager.canAdmin(f, spaceUser, spaceUserOrganizations)
				JsonRoutes.sendResult res,
					code: 401,
					data:
						"error": "Validate Request -- No permission, flow is #{f._id}",
						"success": false
				return;
		i++


	query.flow = {$in: flowIds}

	query.space = spaceId

	if req.query?.sync_token
		sync_token = new Date(Number(req.query.sync_token))
		query.modified = {$gt: sync_token}

	if req.query?.state
		query.state = {$in: req.query.state.split(",")}
	else
		query.state = "completed"

#	最多返回500条数据
	instances = db.instances.find query, {fields: {inbox_uers: 0, cc_users: 0, outbox_users: 0, traces: 0}, skip: 0, limit: 500}

	JsonRoutes.sendResult res,
			code: 200,
			data:
				"status": "success",
				"sync_token": ret_sync_token
				"data": instances.fetch()
	return;
