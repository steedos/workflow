###
@api {put} /api/workflow/open/save/:ins_id 暂存申请单

@apiName saveInstances

@apiGroup Workflow

@apiPermission 工作区管理员

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

		values = req.body

		if not values
			throw new Meteor.Error('error', 'need values')

		current_trace = null
		setObj = new Object
		instance = uuflowManager.getInstance(ins_id)
		flow = uuflowManager.getFlow(instance.flow)

		_.each instance.traces, (t)->
			if t.is_finished isnt true
				current_trace = t

		current_step = uuflowManager.getStep(instance, flow, current_trace.step)

		if current_step.step_type is "counterSign"
			throw new Meteor.Error('error', '会签步骤不能修改表单值')

		_.each current_trace.approves, (a)->
			if a.is_finished isnt true and a.type isnt "cc"
				a.values = values

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
