###
@api {get} /api/workflow/open/get/:ins_id 查看申请单详情

@apiName getInstance

@apiGroup Workflow

@apiPermission 仅以下人员可以查看申请单详情：提交者、申请者、经手者、本流程的管理员、本流程的观察员、工作区的管理员

@apiParam {String} ins_id 申请单Id
@apiParam {String} access_token User API Token

@apiHeader {String} X-Space-Id	工作区Id

@apiHeaderExample {json} Header-Example:
{
	"X-Space-Id": "wsw1re12TdeP223sC"
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
            "values": {...}
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
            "values": {...}
        }
    ]
}
###
JsonRoutes.add 'get', '/api/workflow/open/get/:ins_id', (req, res, next) ->
	try
		ins_id = req.params.ins_id

		if !Steedos.APIAuthenticationCheck(req, res)
			return ;

		current_user = req.userId

		space_id = req.headers['x-space-id']

		if not space_id
			throw new Meteor.Error('error', 'need header X_Space_Id')

		# 校验space是否存在
		uuflowManager.getSpace(space_id)
		# 校验当前登录用户是否是space的管理员
		uuflowManager.isSpaceAdmin(space_id, current_user)

		instance = db.instances.findOne(ins_id)
		if not instance
			throw new Meteor.Error('error', 'can not find user')

		if db.space_users.find({space: instance.space, user: current_user}).count() is 0
			throw new Meteor.Error('error', 'auth_token is wrong')

		# 权限：仅以下人员可以查看申请单详情：提交者、申请者、经手者、本流程的管理员、本流程的观察员、本工作区的管理员、本工作区的所有者。
		perm_users = new Array
		perm_users.push(instance.submitter)
		perm_users.push(instance.applicant)
		if instance.outbox_users
			perm_users = perm_users.concat(instance.outbox_users)
		if instance.inbox_users
			perm_users = perm_users.concat(instance.inbox_users)
		space = db.spaces.findOne(instance.space)
		perm_users = perm_users.concat(space.admins)

		permissions = permissionManager.getFlowPermissions(instance.flow, current_user)

		if (not perm_users.includes(current_user)) and (not permissions.includes("monitor")) and (not permissions.includes("admin"))
			throw new Meteor.Error('error', 'no permission')

		JsonRoutes.sendResult res,
			code: 200
			data: { status: "success", data: instance}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}]}
	
		