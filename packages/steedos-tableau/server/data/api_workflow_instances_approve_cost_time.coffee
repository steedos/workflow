###
   参数：
    username: (工作区管理员)登录名
    password: (工作区管理员)登录密码
    sync_token: 时间戳。如果传入，则返回此时间段之后的申请单
    state: 申请单状态。值范围为：draft:草稿，pending：进行中，completed: 已完成。默认为completed
    approve: 是否返回审批信息true/false。默认为false
###
JsonRoutes.add 'get', '/api/workflow/instances/space/:space/approves/cost_time', (req, res, next) ->

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

	aggregate = (aggregate_operation, ins_approves, cb) ->
		db.instances.rawCollection().aggregate aggregate_operation, (err, data) ->

			if err
				throw new Error(err)

			console.log("data.length", data.length)

			data.forEach (doc)->
				ins_approves.push(doc)

			if cb
				cb()
		return

	async_aggregate = Meteor.wrapAsync(aggregate)

	aggregate_operation = [
							{
								$match: query
							},
							{
								$project: {
									flow: 1,
									"_approve": '$traces.approves'
								}
							},
							{
								$unwind: "$_approve"
							}
							{
								$unwind: "$_approve"
							},
							{
								$project: {
									"handler_name": '$_approve.handler_name',
									"handler": '$_approve.handler',
									"cost_time": '$_approve.cost_time',
									"is_finished": '$_approve.is_finished',
									"type": '$_approve.type'
								}
							},{
								$match:{
									"is_finished": true,
									"type": {$ne: "draft"}
								}
							},
							{
								$group : {
									_id : { handler_name: "$handler_name", handler: "$handler"},
									avg_cost_time: { $avg: "$cost_time" },
#									max_cost_time: { $max: "$cost_time" },
#									min_cost_time: { $min: "$cost_time" },
#									sum_cost_time: { $sum: "$cost_time" },
									count: { $sum: 1 }
								}
							}
						]

	console.log aggregate_operation

	console.time("async_aggregate_cost_time")

	async_aggregate(aggregate_operation, ins_approves)

	console.timeEnd("async_aggregate_cost_time")

	JsonRoutes.sendResult res,
		code: 200,
		data:
			"status": "success",
			"sync_token": ret_sync_token
			"data": ins_approves

	return;