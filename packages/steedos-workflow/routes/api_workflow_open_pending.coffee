###
@api {get} /api/workflow/open/pending 获取待办文件

@apiDescription 获取当前用户的待办事项列表

@apiName getInbox

@apiGroup Workflow

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
JsonRoutes.add 'get', '/api/workflow/open/:state', (req, res, next) ->
	try

		if !Steedos.APIAuthenticationCheck(req, res)
			return ;

		space_id = req.headers['x-space-id'] || req.query?.spaceId

		user_id = req.userId

		if !user_id
			throw new Meteor.Error('error', 'Not logged in')

		user = db.users.findOne({_id: user_id})

		state = req.params.state

		limit = req.query?.limit || 500

		limit = parseInt(limit)

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
					$or:[{inbox_users: user_id}, {cc_users: user_id}]
				},{sort:{modified:-1}, limit: limit}).fetch()
			_.each find_instances, (i)->
				flow = db.flows.findOne(i["flow"], {fields: {name: 1}})
				space = db.spaces.findOne(i["space"], {fields: {name: 1}})
				return if not flow
				current_trace;
				if i.inbox_users?.includes(user_id)
					current_trace = _.find i["traces"], (t)->
						return t["is_finished"] is false
				else
					i.traces.forEach (t)->
						t?.approves?.forEach (approve)->
							if approve.user == user_id && approve.type == 'cc' && !approve.is_finished
								current_trace = t
				approves = current_trace?.approves.filterProperty("is_finished", false).filterProperty("handler", user_id);

				start_date = ''

				if approves?.length > 0
					approve = approves[0]
					is_read = approve.is_read
					start_date = approve.start_date

				h = new Object
				h["id"] = i["_id"]
				h["start_date"] = start_date
				h["flow_name"] = flow.name
				h["space_name"] = space.name
				h["name"] = i["name"]
				h["applicant_name"] = i["applicant_name"]
				h["applicant_organization_name"] = i["applicant_organization_name"]
				h["submit_date"] = i["submit_date"]
				h["step_name"] = current_trace?.name
				h["space_id"] = space_id
				h["modified"] = i["modified"]
				h["is_read"] = is_read
				h["values"] = i["values"]
				result_instances.push(h)

		JsonRoutes.sendResult res,
			code: 200
			data: { status: "success", data: result_instances}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [{errorMessage: e.message}]}
	
		