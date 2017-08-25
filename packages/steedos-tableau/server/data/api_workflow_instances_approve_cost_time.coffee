###
   参数：
    username: (工作区管理员)登录名
    password: (工作区管理员)登录密码
    sync_token: 时间戳。如果传入，则返回此时间段之后的申请单
###

JsonRoutes.add 'post', '/tableau/api/workflow/instances/space/:space/approves/cost_time', (req, res, next) ->
	try
		userId = req.userId

		user = db.users.findOne({_id: userId})

		if !userId || !user
			JsonRoutes.sendResult res,
				code: 401,
			return;
	catch e
		if !userId || !user
			JsonRoutes.sendResult res,
				code: 401,
				data:
					"error": e.message,
					"success": false
			return;

	spaceId = req.params.space

	space = db.spaces.findOne({_id: spaceId})

	if !space
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Invalid Space",
				"success": false
		return;

	query = {}

	ret_sync_token = new Date().getTime()

	query.space = spaceId

	period = parseInt(req.body.period) || 0

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

	flows = req.body?.flows?.split(",") || []

	if flows.length > 0
		query.flow = {$in: flows}

	orgs = req.body?.orgs?.split(",") || []

	orgs_childs = db.organizations.find({parents: {$in: orgs}}, {fields: {_id: 1}}).fetch()

	orgs = orgs.concat(orgs_childs.getProperty("_id"))

	orgs_users = db.space_users.find({space: spaceId, organizations: {$in: orgs}}, {fields: {user: 1}}).fetch()

	orgs_users_ids = orgs_users.getProperty("user")

	aggregate = (pipeline, ins_approves, cb) ->
		cursor = db.instances.rawCollection().aggregate pipeline, {cursor: {}}

		cursor.on 'data', (doc) ->

			doc.is_finished = doc._id.is_finished || false

			ins_approves.push(doc);

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
						_id : {"handler_organization_fullname": "$_approve.handler_organization_fullname","handler_name": "$_approve.handler_name", "is_finished": "$_approve.is_finished"}
						avg_cost_time: { $avg: "$_approve.cost_time" },
						approve_count: { $sum: 1 },
						itemsSold: { $push:  { start_date: "$_approve.start_date"} }
					}
				}
			]

	console.log "pipeline", JSON.stringify(pipeline)

	console.time("async_aggregate_cost_time")

	cursor = async_aggregate(pipeline, ins_approves)

	if ins_approves.length > 0

		ins_approves_group = _.groupBy ins_approves, "is_finished"

		finished_approves = ins_approves_group[true]

		inbox_approves = ins_approves_group[false]

		finished_approves.forEach (approve)->

			inbox_approve = _.find(inbox_approves, (item,index)->
				if item._id.handler_organization_fullname == approve._id.handler_organization_fullname && item._id.handler_name == approve._id.handler_name
					inbox_approves.remove(index)
					return true
			)

			approve.inbox_approve_count = inbox_approve?.approve_count

			delete approve.is_finished

			delete approve.itemsSold

		inbox_approves?.forEach (approve)->
			finished_approves.push {_id: approve._id, avg_cost_time: 0, approve_count: 0, inbox_approve_count: approve.approve_count}
	else

		finished_approves = []

	console.timeEnd("async_aggregate_cost_time")

	JsonRoutes.sendResult res,
		code: 200,
		data:
			"status": "success",
			"sync_token": ret_sync_token,
			"data": finished_approves

	return;