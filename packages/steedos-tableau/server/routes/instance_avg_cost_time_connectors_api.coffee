###
    此接口不做安全校验
###


JsonRoutes.add 'get', '/tableau/workflow/space/:space/cost_time', (req, res, next) ->
	console.log "/api/workflow/tableau/..."
	spaceId = req.params.space

	space = db.spaces.findOne({_id: spaceId})

	if !space?.is_paid
		JsonRoutes.sendResult res,
			code: 404,
			data:
				"error": "Validate Request -- Non-paid space.",
				"success": false
		return;

	html = ""

	if space
		connName = "审批效率统计:" + space.name

		html = Assets.getText("assets/instances/instance_avg_cost_time_connectors.html")

		html = html.replace('#{spaceId}', spaceId).replace('#{spaceName}', space.name).replace('#{dataServerOrigin}', Meteor.absoluteUrl()).replace('#{connName}', connName)

	res.statusCode = 200
	res.end(html)


