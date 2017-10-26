###
Content-Type：application/json
body 格式:
{
	"approve": {
		"_id": "xx",
		"values": {
			...
		}
	}
}
###
JsonRoutes.add 'put', '/api/workflow/open/save/:ins_id', (req, res, next) ->
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

		approve = hashData["approve"]

		if not approve
			throw new Meteor.Error('error', 'need approve')

		if not approve._id
			throw new Meteor.Error('error', 'need approve._id')

		if not approve.values
			throw new Meteor.Error('error', 'need approve.values')

		approve_id = approve._id
		values = approve.values
		current_trace = null
		setObj = new Object
		instance = uuflowManager.getInstance(ins_id)
		
		_.each instance.traces, (t)->
			_.each t.approves, (a)->
				if a._id is approve_id
					a.values = values
					current_trace = t

		setObj.modified = new Date
		setObj["traces.$.approves"] = current_trace.approves

		db.instances.update {
			_id: ins_id
			'traces._id': current_trace._id
		}, $set: setObj

		result = new Object

		JsonRoutes.sendResult res,
			code: 200
			data: { status: "success", data: result}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}]}
