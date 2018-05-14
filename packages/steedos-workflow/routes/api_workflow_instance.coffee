JsonRoutes.add 'get', '/api/workflow/instance/:instanceId', (req, res, next) ->
	try
		current_user_info = uuflowManager.check_authorization(req, res)
		current_user_id = current_user_info._id

		insId = req.params.instanceId

		ins = db.instances.findOne(insId, { fields: { space: 1, state: 1, inbox_users: 1, cc_users: 1, outbox_users: 1 } })

		if not ins
			throw new Meteor.Error('error', 'instanceId is wrong or instance not exists.')

		spaceId = ins.space

		if db.space_users.find({ space: spaceId, user: current_user_id }).count() is 0
			throw new Meteor.Error('error', 'user is not belong to this space.')

		box = ''

		if (ins.inbox_users?.includes current_user_id) or (ins.cc_users?.includes current_user_id)
			box = 'inbox'
		else if ins.outbox_users?.includes current_user_id
			box = 'outbox'
		else if ins.state is 'draft'
			box = 'draft'
		else
			box = 'monitor'

		redirectTo = Meteor.absoluteUrl "workflow/space/#{spaceId}/#{box}/#{insId}"

		res.setHeader "Location", redirectTo
		res.writeHead 302
		res.end()
		return
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}] }
