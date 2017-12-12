###
@api {post} /api/workflow/open/getbystepname 根据步骤名称获取申请单

@apiName getInstanceByStepName

@apiGroup Workflow

@apiPermission 工作区管理员

@apiParam {String} access_token User API Token

@apiHeader {String} X-Space-Id	工作区Id

@apiHeaderExample {json} Header-Example:
{
	"X-Space-Id": "wsw1re12TdeP223sC"
}

@apiParamExample {json} Request Payload:
{
    "flow": 流程Id,
    "stepname": 步骤名称
}

@apiSuccessExample {json} Success-Response:
{
	"status": "success",
	"data": [
		{
			"id": "g7wokXNkR9yxHvA4D",
			"start_date": "2017-11-23T02:28:53.164Z",
			"flow_name": "正文流程",
			"space_name": "审批王",
			"name": "正文流程 1",
			"applicant_name": null,
			"applicant_organization_name": "审批王",
			"submit_date": "2017-07-25T06:36:48.492Z",
			"step_name": "开始",
			"space_id": "kfDsMv7gBewmGXGEL",
			"modified": "2017-11-23T02:28:53.164Z",
			"is_read": false,
			"values": {}
		},
		{
			"id": "WqKSrWQoywgJaMp9k",
			"start_date": "2017-08-17T07:38:35.420Z",
			"flow_name": "正文\n",
			"space_name": "审批王",
			"name": "正文\n 1",
			"applicant_name": "殷亮辉",
			"applicant_organization_name": "审批王",
			"submit_date": "2017-06-27T10:26:19.468Z",
			"step_name": "开始",
			"space_id": "kfDsMv7gBewmGXGEL",
			"modified": "2017-08-17T07:38:35.421Z",
			"is_read": true,
			"values": {}
		}
	]
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
		flow = hashData["flow"]

		if not stepname
			throw new Meteor.Error('error', 'need stepname')

		if not flow
			throw new Meteor.Error('error', 'need flow')

		# 去掉{fields: {inbox_uers: 0, cc_users: 0, outbox_users: 0, traces: 0, attachments: 0}
		instances = db.instances.find({space: space_id, flow: flow, state:'pending', traces:{$elemMatch: {is_finished: false, name: stepname}}}, {fields: {inbox_uers: 0, cc_users: 0, outbox_users: 0, attachments: 0, traces: 0}}).fetch()

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
