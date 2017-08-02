###
   参数：
    username: (工作区管理员)登录名
    password: (工作区管理员)登录密码
    sync_token: 时间戳。如果传入，则返回此时间段之后的申请单
###
JsonRoutes.add 'get', '/api/workflow/instances/space/:space/approves/cost_time/details', (req, res, next) ->
	console.log "/api/workflow/.../cost_time"
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

	console.log "req.params", req.params
	console.log "req.query", req.query

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


	#URL参数
#	states = req.query?.state?.split(",") || ["completed"]

	query = {}

	ret_sync_token = new Date().getTime()

	query.space = spaceId

	query.final_decision = {$ne: "terminated"}

#	limit = 50000

	if req.query?.limit
		limit = parseInt(req.query.limit)

	if req.query?.sync_token
		sync_token = new Date(Number(req.query.sync_token))
		query.modified = {$gt: sync_token}

	query.state = {$in: ["pending", "completed"]}

	fields = {inbox_uers: 0, cc_users: 0, outbox_users: 0}

	ins_approves = new Array()

	flow = db.flows.find({},{fields: {name: 1}}).fetch()

	orgs = req.query?.orgs?.split(",") || []

	orgs_childs = db.organizations.find({parents: {$in: orgs}}, {fields: {_id: 1}}).fetch()

	orgs = orgs.concat(orgs_childs.getProperty("_id"))

	orgs_users = db.space_users.find({space: spaceId, organizations: {$in: orgs}}, {fields: {user: 1}}).fetch()

	orgs_users_ids = orgs_users.getProperty("user")

	aggregate = (pipeline, ins_approves, cb) ->
		cursor = db.instances.rawCollection().aggregate pipeline, {cursor: {}}

		i  = 0;
		cursor.on 'data', (doc) ->
			console.log i

			doc.flow = flow.findPropertyByPK("_id", doc.flow).name

			ins_approves.push(doc)
			i++;

		cursor.once('end', () ->
			cb();
		)

	async_aggregate = Meteor.wrapAsync(aggregate)

	pipeline = [
				{
					$match: query
				},
				{
					$limit: parseInt(req.query?.limit || 4000)
				},
				{
					$project:{
						"flow": 1,
						"ins_state": "$state",
						"ins_state": "$_id",
						"space": "$space",
						"_traces": '$traces'
					}
				},
				{
					$unwind: "$_traces"
				},
				{
					$project:{
						"flow": 1,
						"ins_state": "$state",
						"ins_id": "$_id",
						"space": "$space",
						"step_name": "$_traces.name",
						"_approve": '$_traces.approves'
					}
				},
				{
					$unwind: "$_approve"
				},
				{
					$match: {
						"_approve.type" : {$nin: ["draft", "distribute", "forward"]},
						"_approve.handler" : {$in: orgs_users_ids}
					}
				},
				{
					$project: {
						"_id": "$_approve._id",
						"flow": 1,
						"ins_id": 1,
#									"ins_state": 1,
#									"space": 1,
						"step_name": 1,
#									"approve_id": "$_approve._id",
						"handler_name": "$_approve.handler_name",
						"handler": "$_approve.handler",
						"start_date": "$_approve.start_date",
						"cost_time": "$_approve.cost_time",
						"is_finished": "$_approve.is_finished",
						"type": "$_approve.type"
					}
				}
			]

	console.log "pipeline", JSON.stringify(pipeline)

	console.time("async_aggregate_cost_time")

	cursor = async_aggregate(pipeline, ins_approves)

	console.timeEnd("async_aggregate_cost_time")

	JsonRoutes.sendResult res,
		code: 200,
		data:
			"status": "success",
			"sync_token": ret_sync_token,
			"data": ins_approves

	return;