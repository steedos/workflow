###
@api {post} /api/workflow/open/drafts 新建申请单

@apiName createInstance

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
    "applicant": 申请人Id,
    "values": {
        "fields1" : 字段值,
        "fields2" : 字段值,
        ...
    }
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

@apiErrorExample {json} error-Response:
{
    "status": "error",
    "data": {...}
}
###
JsonRoutes.add 'post', '/api/workflow/open/drafts', (req, res, next) ->
	try

		if !Steedos.APIAuthenticationCheck(req, res)
			return ;

		user_id = req.userId

		current_user_info = db.users.findOne({_id: user_id})

		space_id = req.headers['x-space-id']

		if not space_id
			throw new Meteor.Error('error', 'need header x_space_id')

		# 校验space是否存在
		uuflowManager.getSpace(space_id)
		# 校验当前登录用户是否是space的管理员
		uuflowManager.isSpaceAdmin(space_id, current_user_info._id)

		hashData = req.body

		if not hashData["flow"]
			throw new Meteor.Error('error', 'flow is null')

		flow_id      = hashData["flow"]
		applicant_id = hashData["applicant"]

		instance_from_client = new Object

		flow = db.flows.findOne(flow_id)
		if not flow
			throw new Meteor.Error('error', 'flow is null')

		if space_id isnt flow.space
			throw new Meteor.Error('error', 'flow is not belong to this space')

		if db.space_users.find({space: space_id, user: current_user_info._id}).count() is 0
			throw new Meteor.Error('error', 'auth_token is not a member of this space')

		instance_from_client["space"] = space_id
		instance_from_client["flow"] = flow_id
		instance_from_client["flow_version"] = flow.current._id

		if applicant_id
			applicant = db.users.findOne(applicant_id)
			if not applicant
				throw new Meteor.Error('error', 'applicant is wrong')

			space_user = uuflowManager.getSpaceUser(space_id, applicant_id)
			if not space_user
				throw new Meteor.Error('error', 'applicant is not a member of this space')

			if space_user.user_accepted isnt true
				throw new Meteor.Error('error', 'applicant is disabled in this space')

#			space_user_org_info = uuflowManager.getSpaceUserOrgInfo(space_user)
#			instance_from_client["applicant"] = applicant._id
#			instance_from_client["applicant_name"] = applicant.name
#			instance_from_client["applicant_organization"] =  space_user_org_info["organization"]
#			instance_from_client["applicant_organization_fullname"] = space_user_org_info["organization_fullname"]
#			instance_from_client["applicant_organization_name"] = space_user_org_info["organization_name"]

		traces = []
		trace = new Object
		approves = []
		approve = new Object
		approve["values"] = hashData["values"]
		approves.push(approve)
		trace["approves"] = approves
		traces.push(trace)
		instance_from_client["traces"] = traces

		instance_from_client["inbox_users"] = [applicant?._id || current_user_info._id]

		new_ins_id = uuflowManager.create_instance(instance_from_client, applicant || current_user_info)

		new_ins = db.instances.findOne(new_ins_id)

		JsonRoutes.sendResult res,
			code: 200
			data: { status: "success", data: new_ins}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}]}
	
		