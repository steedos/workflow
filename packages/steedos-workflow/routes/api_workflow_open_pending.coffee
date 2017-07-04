JsonRoutes.add 'get', '/api/workflow/open/pending', (req, res, next) ->
	try
		user_id = req.headers['x-user-id']

		auth_token = req.headers['x-auth-token']

		space_id = req.headers['x-space-id']

		user = Steedos.getAPILoginUser(req, res)
		
		if !user
			JsonRoutes.sendResult res,
				code: 401,
				data:
					"error": "Validate Request -- Missing X-Auth-Token,X-User-Id",
					"success": false
			return;

		state = req.query.state
		#user_id = req.query.userid

		if not state
			throw new Meteor.Error('error', 'state is null')

		# 校验space是否存在
		uuflowManager.getSpace(space_id)

		find_instances = new Array
		result_instances = new Array

		if "pending" is state
			if user_id
				find_instances = db.instances.find({
					space: space_id,
					state: "pending",
					$or:[{inbox_users: user_id}, {cc_users: user_id}]
				},{sort:{modified:-1}}).fetch()
			else
				# 校验当前登录用户是否是space的管理员
				uuflowManager.isSpaceAdmin(space_id,user_id)
				find_instances = db.instances.find({
					space: space_id,
					state: "pending"
				}).fetch()

			_.each find_instances, (i)->
				flow = db.flows.findOne(i["flow"])
				space = db.spaces.findOne(i["space"])
				return if not flow
				current_trace = _.find i["traces"], (t)->
					return t["is_finished"] is false
				current_step_id = current_trace["step"]
				step = uuflowManager.getStep(i, flow, current_step_id)

				approves = current_trace.approves.filterProperty("is_finished", false).filterProperty("handler", user_id);
				if approves.length > 0
					approve = approves[0]
					is_read = approve.is_read

				h = new Object
				h["id"] = i["_id"]
				h["flow_name"] = flow.name
				h["space_name"] = space.name
				h["name"] = i["name"]
				h["applicant_name"] = i["applicant_name"]
				h["applicant_organization_name"] = i["applicant_organization_name"]
				h["submit_date"] = i["submit_date"]
				h["step_name"] = step.name
				h["space_id"] = space_id
				h["modified"] = moment(i["modified"]).format('YYYY-MM-DD HH:mm')
				h["is_read"] = is_read
				result_instances.push(h)

		JsonRoutes.sendResult res,
			code: 200
			data: { status: "success", data: result_instances}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}]}
	
		