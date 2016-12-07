Cookies = Npm.require("cookies")
#TODO 样式调整
JsonRoutes.add "get", "/workflow/space/:space/view/readonly/:instance_id", (req, res, next) ->
#	console.log req
	cookies = new Cookies(req, res);

	# first check request body
	if req.body
		userId = req.body["X-User-Id"]
		authToken = req.body["X-Auth-Token"]

	# then check cookie
	if !userId or !authToken
		userId = cookies.get("X-User-Id")
		authToken = cookies.get("X-Auth-Token")

	if !(userId and authToken)
		JsonRoutes.sendResult res,
			code: 401,
			data:
				"error": "Validate Request -- Missing X-Auth-Token",
				"instance": "1329598861",
				"success": false

	#	TODO 用户权限验证

	user = db.users.findOne({_id: userId})

	instanceId = req.params.instance_id

	space = req.params.space

	instance = db.instances.findOne({_id: instanceId});

	#TODO 将获取body的代码抽取成函数
	body = InstanceReadOnlyTemplate.getInstanceView(user, space, instance);

	if !Steedos.isMobile()
		flow = db.flows.findOne({_id: instance.flow});
		if flow?.instance_style == 'table'
			instance_style = "instance-table"

	trace = InstanceReadOnlyTemplate.getTracesView(user, space, instance)

	hash = (new Date()).getTime()

	instanceBoxStyle = "";

	if instance && instance.final_decision
		if instance.final_decision == "approved"
			instanceBoxStyle = "box-success"
		else if (instance.final_decision == "rejected")
			instanceBoxStyle = "box-danger"

	attachment = InstanceReadOnlyTemplate.getAttachmentView(user, space, instance)

	html = """
		<!DOCTYPE html>
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<link rel="stylesheet" type="text/css" class="__meteor-css__" href="/merged-stylesheets.css?hash=#{hash}">

				<style>
					.steedos{
						width: 960px;
						margin-left: auto;
						margin-right: auto;
					}

					body{
						background: azure !important;
					}
				</style>
			</head>
			<body>
				<div class="steedos">
					<div class="instance #{instance_style}">
						<div class="instance-form box #{instanceBoxStyle}">
							<div class="box-body">
								<div class="col-md-12">
									#{attachment}
									#{body}
								</div>
							</div>
						</div>
					</div>
					#{trace}
				</div>
			</body>
		</html>
	"""

	res.statusCode = 200
	res.end(html)





