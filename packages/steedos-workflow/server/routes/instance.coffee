Cookies = Npm.require("cookies")
#TODO 样式调整
JsonRoutes.add "get", "/workflow/space/:space/view/readonly/:instance_id", (req, res, next) ->
#	console.log req

	cookies = new Cookies( req, res );

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

	form_version =  InstanceReadOnlyTemplate.getInstanceFormVersion(instance)

	steedosData = {instance: instance, form_version: form_version, locale: user.locale, utcOffset: user.utcOffset, space: space}

	hash = (new Date()).getTime()

	instanceTemplate = TemplateManager.getTemplate(instance.flow);

	instanceCompiled = SpacebarsCompiler.compile(instanceTemplate, { isBody: true });

	instanceRenderFunction = eval(instanceCompiled);

	Template.instance_readonly_view = new Blaze.Template("instance_readonly_view", instanceRenderFunction);

	Template.instance_readonly_view.steedosData = steedosData

	Template.instance_readonly_view.helpers InstanceformTemplate.helpers

	InstanceReadOnlyTemplate.init(steedosData);

	#TODO 将获取body的代码抽取成函数
	body = Blaze.toHTMLWithData(Template.instance_readonly_view, steedosData)

	html = """
		<!DOCTYPE html>
		<html>
			<head>
				<link rel="stylesheet" type="text/css" class="__meteor-css__" href="/merged-stylesheets.css?hash=#{hash}">
			</head>
			<body>
				<div class="steedos workflow">
					<div class="skin-green skin-admin-lte">
						<div class="wrapper">
							<div class="content-wrapper" style='min-height: 577px'>
								<div class="workflow-main instance-show">
									<div class="instance-wrapper">
										<div class="instance">
											<div class="instance-form box">
												<div class="box-body">
													<div class="col-md-12">
														#{body}
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</body>
		</html>
	"""

	res.statusCode = 200
	res.end(html)





