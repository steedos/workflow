###
    此接口不做安全校验
###


JsonRoutes.add 'get', '/tableau/workflow/space/:space/flow/:flow', (req, res, next) ->
	flowId = req.params.flow

	flow = db.flows.findOne({_id: flowId});

	spaceId = req.params.space

	space = db.spaces.findOne({_id: spaceId})

	if !space
		JsonRoutes.sendResult res,
			code: 404,
			data:
				"error": "Validate Request -- Miss space.",
				"success": false
		return;

	html = ""

	if flow && space
		connName = space.name + ":" + flow.name

		valueFields = []

		form = db.forms.findOne({_id: flow.form}, {fields: {"current.fields": 1}})

		fields = form.current.fields

		fields.forEach (field, i)->
			if field.type != 'table'

				switch field.type
					when 'date'
						dataType = 'date'
					when 'datetime'
						dataType = 'datetime'
					when 'number'
						dataType = 'float'
					when 'checkbox'
						dataType = 'bool'
					else
						dataType = "string"

				valueFields.push {
					id: "field#{i}",
					code: field.code,
					alias: field.name || field.code,
					dataType: dataType
				}

		html = Assets.getText("assets/instances/instance_by_flow_tableau_connectors.html")

		html = html.replace('#{spaceId}', spaceId).replace('#{spaceName}', space.name).replace('#{dataServerOrigin}', Meteor.absoluteUrl()).replace('#{connName}', connName).replace('#{flowId}', flowId).replace('#{valueFields}', JSON.stringify(valueFields))

		if !space.is_paid
			html = html.replace('#{readonly}', 'readonly')

	res.statusCode = 200
	res.end(html)


