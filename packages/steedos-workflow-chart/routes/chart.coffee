FlowversionAPI =

	writeResponse: (res, httpCode, body)->
		res.statusCode = httpCode;
		res.end(body);
		
	sendInvalidURLResponse: (res)->
		return @writeResponse(res, 404, "url must has querys as instance_id.");
		
	sendAuthTokenExpiredResponse: (res)->
		return @writeResponse(res, 401, "the auth_token has expired.");

	generateGraphSyntax: (steps)->
		# 该函数返回以下格式的graph脚本
		# graphSyntax = '''
		# 	graph LR
		# 		A-->B
		# 		A-->C
		# 		B-->C
		# 		C-->A
		# 		D-->C
		# 	'''
		nodes = ["graph TB"]
		steps.forEach (step)->
			lines = step.lines
			if lines?.length
				lines.forEach (line)->
					if step.name
						# 把特殊字符清空或替换，以避免mermaidAPI出现异常
						stepName = step.name.replace(/[\r\n]/g,"").replace(/[？]/g,"?").replace(/[、]/g,",").replace(/[“”‘’]/g,"'").replace(/[！]/g,"!").replace(/[：]/g,":").replace(/[~]/g,"--").replace(/[·]/g,"`")
					else
						stepName = ""
					toStepName = steps.findPropertyByPK("_id",line.to_step).name
					toStepName = toStepName.replace(/[\r\n]/g,"").replace(/[？]/g,"?").replace(/[、]/g,",").replace(/[“”‘’]/g,"'").replace(/[！]/g,"!").replace(/[：]/g,":").replace(/[~]/g,"--").replace(/[·]/g,"`")
					nodes.push "	#{step._id}(<div class='graph-node'><div class='step-name'>#{stepName}</div></div>)-->#{line.to_step}(#{toStepName})"

		graphSyntax = nodes.join "\n"
		return graphSyntax

	sendHtmlResponse: (req, res)->
		query = req.query
		instance_id = query.instance_id

		unless instance_id
			FlowversionAPI.sendInvalidURLResponse res 

		error_msg = ""
		graphSyntax = ""
		instance = db.instances.findOne instance_id,{fields:{flow_version:1,flow:1}}
		if instance
			flowversion = WorkflowManager.getInstanceFlowVersion(instance)
			steps = flowversion?.steps
			if steps?.length
				graphSyntax = this.generateGraphSyntax steps
			else
				error_msg = "没有找到当前申请单的流程步骤数据"
		else
			error_msg = "当前申请单不存在或已被删除"

		return @writeResponse res, 200, """
			<!DOCTYPE html>
			<html>
				<head>
					<meta charset="utf-8">
					<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
					<title>Workflow Chart</title>
					<link rel="stylesheet" href="/packages/steedos_workflow-chart/assets/mermaid/dist/mermaid.css"/>
					<script type="text/javascript" src="/packages/steedos_workflow-chart/assets/jquery/jquery-1.11.2.min.js"></script>
					<script type="text/javascript" src="/packages/steedos_workflow-chart/assets/mermaid/dist/mermaid.min.js"></script>
					<style>
						body { 
							font-family: 'Source Sans Pro', 'Helvetica Neue', Helvetica, Arial, sans-serif;
							text-align: center;
						}
						.loading{
							position: absolute;
							left: 0px;
							right: 0px;
							top: 50%;
							z-index: 1100;
							text-align: center;
							margin-top: -30px;
							font-size: 36px;
							color: #dfdfdf;
						}
						.error-msg{
							position: absolute;
							left: 0px;
							right: 0px;
							bottom: 20px;
							z-index: 1100;
							text-align: center;
							font-size: 20px;
							color: #a94442;
						}
					</style>
				</head>
				<body>
					<div class = "loading">Loading...</div>
					<div class = "error-msg">#{error_msg}</div>
					<div class="mermaid">#{graphSyntax}</div>
					<script type="text/javascript">
						mermaidAPI.initialize({
							startOnLoad:false
						});
						$(function(){
							var graphSyntax = $('.mermaid').text();
							console.log(graphSyntax)
							$(".loading").remove();
							var svgs = mermaidAPI.render('flow-steps-svg', graphSyntax);
							$('.mermaid').html(svgs);
						});
					</script>
				</body>
			</html>
		"""



JsonRoutes.add 'get', '/api/workflow/chart?instance_id=:instance_id', (req, res, next) ->
	FlowversionAPI.sendHtmlResponse req, res


