Meteor.startup ()->
	JsonRoutes.add "get", "/records/search", (req, res, next) ->
		#传入的参数  ----  draw：直接返回|columns:列|start:开始|length：页长度|...|自定义参数...
		#从ES中查询数据
		jsonData={
			"draw":0,
			"recordsTotal":0,
			"recordsFiltered":0,
			"data":[]
		}
		if req.query.q == "" || req.query.q == null
			JsonRoutes.sendResult res,data:jsonData
			return
		address = Meteor.settings.public.webservices?.elasticsearch?.url
		index = Meteor.settings.records.es_search_index
		type = "instances"
		from = req.query.start + ""
		size = req.query.length + ""
		q = req.query.q + ""
		userId = req.query.userId
		minitorFlowArrs = []
		# 查询
		data = {
			"query": {
				"bool" : {
					"must" : {
						"multi_match": {
							"query": q,
							"type": "cross_fields",
							"fields": [
								"name",
								"values",
								"attachments.*"
							],
							"operator": "or"
						}
					}
				}
			},
			"highlight": {
				"pre_tags":["<strong>"],
				"post_tags":["</strong>"],
				"fields": {
					"name":{},
					"values": {},
					"attachments.*": {}
				}
			}
		}
		# isSpaceAdmin看当前用户是工作区管理员，直接搜索
		# 不是系统管理员，则根据流程和用户名过滤搜索
		isSpaceAdmin = req?.query?.isSpaceAdmin
		# console.log !isSpaceAdmin
		if isSpaceAdmin == "false"
			# 1.查找当前用户可以监控的flow
			# flowObjs = db.flows.find({$or:[
			# 					{'perms.users_can_add':userId},
			# 					{'perms.users_can_monitor':userId},
			# 					{'perms.users_can_admin':userId}
			# 				]},{_id:1})

			# flowObjs.forEach (flowObj)->
			# 	if minitorFlowArrs.indexOf(flowObj?._id)==-1
			# 		minitorFlowArrs.push flowObj._id

			# 2.查找当前用户所在部门可以监控的flow
			# orgObjs = db.organizations.find({'users':userId},{_id:1})
			# orgArr = []
			# orgObjs.forEach (orgObj)->
			# 	if orgArr.indexOf(orgObj?._id)==-1
			# 		orgArr.push orgObj?._id

			# flowObjs = db.flows.find({$or:[
			# 					{'perms.orgs_can_add':{$in:orgArr}},
			# 					{'perms.orgs_can_monitor':{$in:orgArr}},
			# 					{'perms.orgs_can_admin':{$in:orgArr}}
			# 				]},{_id:1})
			# flowObjs.forEach (flowObj)->
			# 	if minitorFlowArrs.indexOf(flowObj?._id)==-1
			# 		minitorFlowArrs.push flowObj._id

			# console.log minitorFlowArrs

			data?.query?.bool?.filter = {
											"bool": {
												"should": [
													{
														"match": {
															"users": {
																"query": userId,
																"type": "phrase"
															}
														}
													}
													# ,
													# {
													# 	"terms":{
													# 		"flow":minitorFlowArrs
													# 	}
													# }
												]
											}
										}

		# console.log data

		query_url = address + "/" + index + "/" + type + "/_search"
		
		params = {size:size,from:from}
		result = HTTP.call(
			'POST',
			query_url,
			{
				params: params,
				data: data
			}
		)
		if result.statusCode == 200
			srcData = result.data.hits
			jsonData.recordsTotal = srcData.total
			jsonData.recordsFiltered = srcData.total
			jsonData.data = srcData.hits
		else
			jsonData.error = "网络异常！"
		JsonRoutes.sendResult res,data:jsonData
		return
