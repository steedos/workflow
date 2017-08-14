###
   参数：
    username: (工作区管理员)登录名
    password: (工作区管理员)登录密码
    sync_token: 时间戳。如果传入，则返回此时间段之后的申请单
###
JsonRoutes.add 'get', '/api/workflow/instances/space/:space/approves/cost_time', (req, res, next) ->
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

#	if !Steedos.isSpaceAdmin(spaceId, user._id)
#		JsonRoutes.sendResult res,
#			code: 401,
#			data:
#				"error": "Validate Request -- No permission",
#				"success": false
#		return;


	#URL参数
#	states = req.query?.state?.split(",") || ["completed"]

	query = {}

	ret_sync_token = new Date().getTime()

	query.space = spaceId

	period = parseInt(req.query.period) || 0

	start_date = new Date();

	start_date.setMonth(start_date.getMonth() - period)

	query.submit_date = {$gt: start_date}

	query.is_deleted = false

	query.final_decision = {$ne: "terminated"}

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

		cursor.on 'data', (doc) ->
			ins_approves.push(doc)

		cursor.once('end', () ->
			cb();
		)

	async_aggregate = Meteor.wrapAsync(aggregate)

	pipeline = [
				{
					$match: query
				},
				{
					$project:{
						"_approve": '$traces.approves'
					}
				},
				{
					$unwind: "$_approve"
				},
				{
					$unwind: "$_approve"
				},
				{
					$match: {
						"_approve.type" : {$nin: ["draft", "distribute", "forward"]},
						"_approve.handler" : {$in: orgs_users_ids}
					}
				},{
					$group : {
						_id : {"handler_organization_fullname": "$_approve.handler_organization_fullname","handler_name": "$_approve.handler_name"},
						avg_cost_time: { $avg: "$_approve.cost_time" },
						approve_count: { $sum: 1 }
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