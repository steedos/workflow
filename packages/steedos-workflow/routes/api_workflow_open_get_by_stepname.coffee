###
Content-Type：application/json
body格式:
{
	"stepname": xxx 
}
返回数据格式
{
	status: "success",
	data: {
		"instances": [
			...
		]
	}
}
###
JsonRoutes.add 'post', '/api/workflow/open/getbystepname', (req, res, next) ->
	try

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
		stepname = hashData["stepname"]

		if not stepname
			throw new Meteor.Error('error', 'need stepname')

		# 去掉{fields: {inbox_uers: 0, cc_users: 0, outbox_users: 0, traces: 0, attachments: 0}
		instances = db.instances.find({space: space_id, "traces.name": stepname}, {fields: {inbox_uers: 0, cc_users: 0, outbox_users: 0, traces: 0, attachments: 0}}).fetch()
		instances.forEach (instance)->

			attachments = cfs.instances.find({'metadata.instance': instance._id,'metadata.current': true, "metadata.is_private": {$ne: true}}, {fields: {copies: 0}}).fetch()

			instance.attachments = attachments

		JsonRoutes.sendResult res,
			code: 200
			data: { status: "success", data: instances}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}]}
