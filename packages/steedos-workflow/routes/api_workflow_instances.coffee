
###
   参数：
    username: (工作区管理员)登录名
    password: (工作区管理员)登录密码
    sync_token: 时间戳。如果传入，则返回此时间段之后的申请单
    state: 申请单状态。值范围为：draft:草稿，pending：进行中，completed: 已完成。默认为completed
    approve: 是否返回审批信息true/false。默认为false
###
JsonRoutes.add 'get', '/api/workflow/instances/space/:space/flow/:flow', (req, res, next) ->

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

	flowId = req.params.flow

	flow = db.flows.findOne({_id: flowId})

	if !flow
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Invalid Flow",
				"success": false
		return;

	query = {}

	if !Steedos.isSpaceAdmin(spaceId, user._id)

		spaceUser = db.space_users.findOne({space: space._id, user: user._id})

		organizations = db.organizations.find({
			_id: {
				$in: spaceUser.organizations
			}
		}).fetch();

		if !WorkflowManager.canMonitor(flow, spaceUser, organizations) && !WorkflowManager.canAdmin(flow, spaceUser, organizations)
			query.applicant = user._id

	#URL参数
	states = req.query?.state?.split(",") || ["completed"]

	returnApprove = false

	if req.query?.approve
		query_approve = req.query.approve.toLocaleLowerCase()

		if query_approve == '1' || query_approve == 'true' || query_approve == 't'
			returnApprove = true

	ret_sync_token = new Date().getTime()

	period = parseInt(req.query.period) || 0

	if !space.is_paid
		period = 1

	if period !=0

		start_date = new Date();

		start_date.setMonth(start_date.getMonth() - period)

		query.submit_date = {$gt: start_date}

	query.flow = flowId

	query.space = spaceId

	query.final_decision = {$ne: "terminated"}

	if req.query?.sync_token
		sync_token = new Date(Number(req.query.sync_token))
		query.modified = {$gt: sync_token}

	query.state = {$in: states}

	fields = {inbox_uers: 0, cc_users: 0, outbox_users: 0}

	if returnApprove
		fields["traces.approves.values"] = 0
	else
		fields.traces = 0

	console.log(JSON.stringify(query))

	instances = db.instances.find query, {fields: fields}

	JsonRoutes.sendResult res,
		code: 200,
		data:
			"status": "success",
			"sync_token": ret_sync_token
			"data": instances.fetch()

	return;