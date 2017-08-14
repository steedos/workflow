###
   参数：
    username: (工作区管理员)登录名
    password: (工作区管理员)登录密码
    sync_token: 时间戳。如果传入，则返回此时间段之后的申请单
    state: 申请单状态。值范围为：draft:草稿，pending：进行中，completed: 已完成。默认为completed
    approve: 是否返回审批信息true/false。默认为false
###
JsonRoutes.add 'get', '/api/space/:space/organizations', (req, res, next) ->

	try
		user = Steedos.getAPILoginUser(req, res)

		if !user
			JsonRoutes.sendResult res,
				code: 401,
				data:
					"error": "Validate Request -- Missing X-Auth-Token,X-User-Id",
					"success": false
			return;
	catch e
		if !user
			JsonRoutes.sendResult res,
				code: 401,
				data:
					"error": e.message,
					"success": false
			return;

	spaceId = req.params.space || req.headers["x-space-id"]

	space = db.spaces.findOne({_id: spaceId})

	if !space
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Invalid Space",
				"success": false
		return;

	if !Steedos.isSpaceAdmin(spaceId, user._id)
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- No permission",
				"success": false
		return;

	query = {}

	ret_sync_token = new Date().getTime()

	query.space = spaceId

	console.time("api_space_organizations")

	organizations = db.organizations.find({query}, {fields: {name:1, fullname: 1, is_company: 1, parents: 1, chidren: 1, users: 1, sort_no: 1}})

	console.timeEnd("api_space_organizations")

	JsonRoutes.sendResult res,
		code: 200,
		data:
			"status": "success",
			"sync_token": ret_sync_token
			"data": organizations.fetch()

	return;