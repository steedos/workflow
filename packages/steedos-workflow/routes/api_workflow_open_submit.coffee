JsonRoutes.add 'put', '/api/workflow/open/submit/:ins_id', (req, res, next) ->
	try
		ins_id = req.params.ins_id

		if !Steedos.APIAuthenticationCheck(req, res)
			return ;

		current_user = req.userId

		space_id = req.headers['x-space-id']

		if not space_id
			throw new Meteor.Error('error', 'need header X_Space_Id')

		current_user_info = db.users.findOne(current_user)

		if not current_user_info
			throw new Meteor.Error('error', 'can not find user')

		# 校验space是否存在
		uuflowManager.getSpace(space_id)
		# 校验当前登录用户是否是space的管理员
		uuflowManager.isSpaceAdmin(space_id, current_user)

		hashData = req.body

		if not hashData["nextstep_name"]
			throw new Meteor.Error('error', 'nextstep_name is null')
		if not hashData["nextstep_users"]
			throw new Meteor.Error('error', 'nextstep_name is null')

		submited_instances = new Array
		updated_flows      = new Array
		nextstep_name  = hashData["nextstep_name"]
		nextstep_users = hashData["nextstep_users"]

		instance = db.instances.findOne(ins_id)
		if space_id isnt instance["space"]
			throw new Meteor.Error('error', 'instance is not belong to this space')

		flow_id = instance["flow"]
		flow_version = instance["flow_version"]
		flow = uuflowManager.getFlow(flow_id)
		next_steps = new Array
		next_step = new Object
		next_users = new Array

		cur = null
		nextstep_id = null
		if flow_version is flow.current._id
			cur = flow.current
		else
			cur = _.find flow.historys, (h)->
				return flow_version is h._id

		_.each cur.steps, (step)->
			if step.name is nextstep_name
				nextstep_id = step._id

		_.each nextstep_users, (e)->
			u = db.users.find(e).count()
			if u is 0
				throw new Meteor.Error('error', '#{e} is not found')
			uuflowManager.getSpaceUser(space_id, e)
			next_users.push(e)

		if not nextstep_id
			throw new Meteor.Error('error', '#{nextstep_name} is not found')

		if next_users.length is 0
			throw new Meteor.Error('error', '#{nextstep_users} is wrong')

		next_step["step"]  = nextstep_id
		next_step["users"] =  next_users
		instance["traces"][0]["approves"][0]["next_steps"] = [next_step]
		result = new Object
		r = uuflowManager.submit_instance(instance, current_user_info)
		if r.alerts
			result = r
		else
			result = db.instances.findOne(ins_id)

		JsonRoutes.sendResult res,
			code: 200
			data: { status: "success", data: result}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}]}
