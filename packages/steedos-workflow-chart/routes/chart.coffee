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

	generateStepsGraphSyntax: (steps, currentStepId, isConvertToString)->
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

	getTraceName: (trace, approve)->
		traceName = trace.name
		if traceName
			# 把特殊字符清空或替换，以避免mermaidAPI出现异常
			traceName = "<div class='graph-node'>
				<div class='trace-name'>#{traceName}</div>
				<div class='trace-handler-name'>#{approve.handler_name}</div>
			</div>"
			traceName = FlowversionAPI.replaceErrorSymbol(traceName)
		else
			traceName = ""
		return traceName

	generateTracesGraphSyntax: (traces, isConvertToString)->
		# 该函数返回以下格式的graph脚本
		# graphSyntax = '''
		# 	graph LR
		# 		A-->B
		# 		A-->C
		# 		B-->C
		# 		C-->A
		# 		D-->C
		# 	'''
		nodes = ["graph LR"]
		toApproves = []
		traces.forEach (trace)->
			lines = trace.previous_trace_ids
			if lines?.length
				lines.forEach (line)->
					fromTrace = traces.findPropertyByPK("_id",line)
					fromApproves = fromTrace.approves
					toApproves = trace.approves
					fromApproves.forEach (fromApprove)->
						if toApproves?.length
							toApproves.forEach (toApprove)->
								if ["cc","forward","distribute"].indexOf(toApprove.type) < 0
									if ["cc","forward","distribute"].indexOf(fromApprove.type) < 0
										fromTraceName = FlowversionAPI.getTraceName fromTrace, fromApprove
										toTraceName = FlowversionAPI.getTraceName trace, toApprove
										nodes.push "	#{fromApprove._id}(\"#{fromTraceName}\")-->#{toApprove._id}(\"#{toTraceName}\")"

						else
							# 结束步骤的trace
							if ["cc","forward","distribute"].indexOf(fromApprove.type) < 0
								fromTraceName = FlowversionAPI.getTraceName fromTrace, fromApprove
								toTraceName = FlowversionAPI.replaceErrorSymbol(trace.name)
								# 不是传阅、分发、转发，则连接到下一个trace
								nodes.push "	#{fromApprove._id}(\"#{fromTraceName}\")-->#{trace._id}(\"#{toTraceName}\")"

						# 一个trace中每个传阅、分发、转发只需要画一次，而不需要每个toApproves都画一次
						if ["cc","forward","distribute"].indexOf(fromApprove.type) >= 0
							ccFromApproveId = fromApprove.from_approve_id
							unless ccFromApproveId
								# 部分老的数据分发、转发的approve中没有from_approve_id，直接忽略不处理
								return
							typeName = ""
							switch fromApprove.type
								when 'cc'
									typeName = "传阅"
								when 'forward'
									typeName = "转发"
								when 'distribute'
									typeName = "分发"
							# 是传阅、分发、转发，则从from_approve_id连接过来
							# 且from_approve_id肯定是当前trace中的approve_id，需要查找到并给定正确的名称
							ccFromApprove = fromTrace.approves.findPropertyByPK("_id",ccFromApproveId)
							fromTraceName = FlowversionAPI.getTraceName fromTrace, ccFromApprove
							if ccFromApprove and ["cc","forward","distribute"].indexOf(ccFromApprove.type) >= 0
								nodes.push "	#{ccFromApproveId}>\"#{fromTraceName}\"]--#{typeName}-->#{fromApprove._id}>\"#{fromApprove.handler_name}\"]"
							else
								nodes.push "	#{ccFromApproveId}(\"#{fromTraceName}\")--#{typeName}-->#{fromApprove._id}>\"#{fromApprove.handler_name}\"]"
			else
				# 第一个trace，因traces可能只有一个，这时需要单独显示出来
				trace.approves.forEach (approve)->
					traceName = FlowversionAPI.getTraceName trace, approve
					nodes.push "	#{approve._id}(\"#{traceName}\")"
				

		# 签批历程中最后的approves高亮显示，结束步骤的trace中是没有approves的，所以结束步骤不高亮显示
		lastApproves = toApproves
		lastApproves?.forEach (lastApprove)->
			nodes.push "	class #{lastApprove._id} current-step-node;"

		if isConvertToString
			graphSyntax = nodes.join "\n"
			return graphSyntax
		else
			return nodes

	sendHtmlResponse: (req, res, type)->
		query = req.query
		instance_id = query.instance_id

		unless instance_id
			FlowversionAPI.sendInvalidURLResponse res 

		error_msg = ""
		graphSyntax = ""
		switch type
			when 'traces'
				instance = db.instances.findOne instance_id,{fields:{traces: 1}}
				if instance
					# currentStepId = instance.traces?[0]?.step
					# flowversion = WorkflowManager.getInstanceFlowVersion(instance)
					traces = instance.traces
					if traces?.length
						graphSyntax = this.generateTracesGraphSyntax traces
					else
						error_msg = "没有找到当前申请单的流程步骤数据"
				else
					error_msg = "当前申请单不存在或已被删除"
			else
				instance = db.instances.findOne instance_id,{fields:{flow_version:1,flow:1,traces: {$slice: -1}}}
				if instance
					currentStepId = instance.traces?[0]?.step
					flowversion = WorkflowManager.getInstanceFlowVersion(instance)
					steps = flowversion?.steps
					if steps?.length
						graphSyntax = this.generateStepsGraphSyntax steps,currentStepId
					else
						error_msg = "没有找到当前申请单的流程步骤数据"
				else
					error_msg = "当前申请单不存在或已被删除"
				break

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
						.node .trace-handler-name{
							color: #777;
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

JsonRoutes.add 'get', '/api/workflow/chart/traces?instance_id=:instance_id', (req, res, next) ->
	FlowversionAPI.sendHtmlResponse req, res, "traces"

