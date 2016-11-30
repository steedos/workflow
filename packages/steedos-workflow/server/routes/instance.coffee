

JsonRoutes.add "get", "/workflow/instance/view/readonly/:instance_id", (req, res, next) ->
	#	TODO 用户登陆验证

	#	TODO 用户权限验证

	instanceId = req.params.instance_id

	instance = db.instances.findOne({_id: instanceId});

	hash = (new Date()).getTime()

	instanceTemplate = TemplateManager.getTemplate(instance.flow);

	#TODO 添加对Template.dynamic 模板引用方式的支持

	instanceTemplate = '''
		{{#each steedos_form.fields}}
		    {{#if includes this.type 'section,table'}}
		        <div class="col-md-12">
		            {{> afFormGroup name=this.code label=false}}
		        </div>
		    {{else}}
		        <div class="{{#if this.is_wide}}col-md-12{{else}}col-md-6{{/if}}">
		        {{> afFormGroup name=this.code}}
		        </div>
		    {{/if}}

		{{/each}}
	'''

	instanceCompiled = SpacebarsCompiler.compile(instanceTemplate, { isBody: true });

	instanceRenderFunction = eval(instanceCompiled);

	Template.instance_readonly_view = new Blaze.Template("instance_readonly_view", instanceRenderFunction);

	Template.instance_readonly_view.helpers InstanceformTemplate.helpers

	#TODO 将获取body的代码抽取成函数
	body = Blaze.toHTMLWithData(Template.instance_readonly_view, instance)

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





