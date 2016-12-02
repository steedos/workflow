
#TODO 样式调整
JsonRoutes.add "get", "/workflow/instance/view/readonly/:instance_id", (req, res, next) ->
	#	TODO 用户登陆验证

	#	TODO 用户权限验证

	instanceId = req.params.instance_id

	instance = db.instances.findOne({_id: instanceId});

	form_version =  InstanceReadOnlyTemplate.getInstanceFormVersion(instance)

	steedosData = {instance: instance, form_version: form_version}

	hash = (new Date()).getTime()

	instanceTemplate = TemplateManager.getTemplate(instance.flow);

	instanceTemplate = instanceTemplate

	instanceCompiled = SpacebarsCompiler.compile(instanceTemplate, { isBody: true });

	instanceRenderFunction = eval(instanceCompiled);

	Template.instance_readonly_view = new Blaze.Template("instance_readonly_view", instanceRenderFunction);

	Template.instance_readonly_view.steedosData = steedosData

	Template.instance_readonly_view.helpers InstanceformTemplate.helpers

	InstanceReadOnlyTemplate.init(steedosData);

	#TODO 将获取body的代码抽取成函数
	body = Blaze.toHTMLWithData(Template.instance_readonly_view, {instance: instance})

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
												#{body}
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





