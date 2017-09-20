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
		if req.query.q==""||req.query.q==null
			JsonRoutes.sendResult res,data:jsonData
			return
		address=Meteor.settings.public.webservices?.elasticsearch?.url
		index=Meteor.settings.records.es_search_index
		type="instances"
		from=req.query.start+""
		size=req.query.length+""
		q=req.query.q+""
		userId=req.query.userId
		query_url=address+"/"+index+"/"+type+"/_search"
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
					},
					"filter" : {
						"match": {
							"users": {
								"query": userId,
								"type": "phrase"
							}
						}
					}
				}
			},
#			"sort": { "modified": { "order": "desc" ,"unmapped_type" : "date"}},
			"highlight": {
				"pre_tags":["<strong>"],
				"post_tags":["</strong>"]
				"fields": {
					"name":{},
					"values": {},
					"attachments.*": {}
				}
			}
		}
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
