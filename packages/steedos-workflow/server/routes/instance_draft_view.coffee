
JsonRoutes.add "get", "/api/workflow/space/:space/view/draft/:flow", (req, res, next)->

	if !Steedos.APIAuthenticationCheck(req, res)
		return ;

	user_id = req.userId

	user = db.users.findOne({_id: user_id})

	spaceId = req.params.space

	flowId = req.params.flow

	space = db.spaces.findOne({_id: spaceId});

	flow = db.flows.findOne({_id: flowId})

	form = db.forms.findOne({_id: flow.form})

	options = {showTrace: false, showAttachments: false, templateName: "default", editable: true}

	spaceUser = db.space_users.findOne({user: user._id, space: spaceId});

	instance = {flow: flow._id ,flow_version: flow.current._id, form: form._id , form_version: form.current._id, values:{}}

	html = InstanceReadOnlyTemplate.getInstanceHtml(user, space, instance, options)

	dataBuf = new Buffer(html);

	res.setHeader('content-length', dataBuf.length)

	res.setHeader('content-range', "bytes 0-#{dataBuf.length - 1}/#{dataBuf.length}")

	res.statusCode = 200

	res.end(html)
