FlowversionAPI =

	writeResponse: (res, httpCode, body)->
		res.statusCode = httpCode;
		res.end(body);
		
	sendInvalidURLResponse: (res)->
		return @writeResponse(res, 404, "url must has querys as instance_id.");
		
	sendAuthTokenExpiredResponse: (res)->
		return @writeResponse(res, 401, "the auth_token has expired.");

	replaceErrorSymbol: (str)->
		return str.replace(/\"/g,"&quot;").replace(/\n/g,"<br/>")

	generateGraphSyntax: (steps, currentStepId, isConvertToString)->
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
						# 标记条件节点
						if step.step_type == "condition"
							nodes.push "	class #{step._id} condition;"
						# 把特殊字符清空或替换，以避免mermaidAPI出现异常
						stepName = "<div class='graph-node'><div class='step-name'>#{step.name}</div></div>"
						stepName = FlowversionAPI.replaceErrorSymbol(stepName)
					else
						stepName = ""
					toStepName = steps.findPropertyByPK("_id",line.to_step).name
					toStepName = FlowversionAPI.replaceErrorSymbol(toStepName)
					nodes.push "	#{step._id}(\"#{stepName}\")-->#{line.to_step}(\"#{toStepName}\")"

		if currentStepId
			nodes.push "	class #{currentStepId} current-step-node;"
		if isConvertToString
			graphSyntax = nodes.join "\n"
			return graphSyntax
		else
			return nodes

	sendHtmlResponse: (req, res)->
		query = req.query
		instance_id = query.instance_id

		unless instance_id
			FlowversionAPI.sendInvalidURLResponse res 

		error_msg = ""
		graphSyntax = ""
		instance = db.instances.findOne instance_id,{fields:{flow_version:1,flow:1,traces: {$slice: -1}}}
		if instance
			currentStepId = instance.traces?[0]?.step
			flowversion = WorkflowManager.getInstanceFlowVersion(instance)
			steps = flowversion?.steps
			if steps?.length
				graphSyntax = this.generateGraphSyntax steps,currentStepId
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
					<script type="text/javascript" src="/lib/jquery/jquery-1.11.2.min.js"></script>
					<script type="text/javascript" src="/packages/steedos_workflow-chart/assets/mermaid/dist/mermaid.min.js"></script>
					<style>
						body { 
							font-family: 'Source Sans Pro', 'Helvetica Neue', Helvetica, Arial, sans-serif;
							text-align: center;
							background-color: #fff;
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
						.node rect{
							fill: #ccccff;
							stroke: rgb(144, 144, 255);
    						stroke-width: 2px;
						}
						.node.current-step-node rect{
							fill: #cde498;
							stroke: #13540c;
							stroke-width: 2px;
						}
						.node.condition rect{
							fill: #ececff;
							stroke: rgb(204, 204, 255);
    						stroke-width: 1px;
						}
					</style>
				</head>
				<body>
					<div class = "loading">Loading...</div>
					<div class = "error-msg">#{error_msg}</div>
					<div class="mermaid"></div>
					<script type="text/javascript">
						mermaidAPI.initialize({
							startOnLoad:false
						});
						$(function(){
							var graphNodes = #{JSON.stringify(graphSyntax)};
							//方便前面可以通过调用mermaid.currentNodes调式，特意增加currentNodes属性。
							mermaid.currentNodes = graphNodes;
							var graphSyntax = graphNodes.join("\\n");
							console.log(graphNodes);
							console.log(graphSyntax);
							console.log("You can access the graph nodes by 'mermaid.currentNodes' in the console of browser.");
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


