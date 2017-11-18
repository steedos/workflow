FlowversionAPI =

	traceCounter: {}

	traceMaxApproveCount: 3

	isExpandApprove: false

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
		# 返回trace节点名称
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

	getTraceName2: (traceName, approveHandlerName)->
		# 返回trace节点名称
		if traceName
			# 把特殊字符清空或替换，以避免mermaidAPI出现异常
			traceName = "<div class='graph-node'>
				<div class='trace-name'>#{traceName}</div>
				<div class='trace-handler-name'>#{approveHandlerName}</div>
			</div>"
			traceName = FlowversionAPI.replaceErrorSymbol(traceName)
		else
			traceName = ""
		return traceName

	getToApproveCount: (trace, approve_id, type)->
		# 查找approve_id对应的二次传阅、分发、转发数量
		if type
			toApproves = trace.approves.filter (item,index)->
				return item.from_approve_id == approve_id and item.type == type
		else
			toApproves = trace.approves.filter (item,index)->
				return item.from_approve_id == approve_id
		return toApproves.length

	pushCCApproveGraphSyntax: (nodes, trace, approve)->
		# 往nodes中push传阅、分发、转发相关的graph脚本
		if ["cc","forward","distribute"].indexOf(approve.type) >= 0
			ccFromApproveId = approve.from_approve_id
			unless ccFromApproveId
				# 部分老的数据分发、转发的approve中没有from_approve_id，直接忽略不处理
				return

			countKey = "#{ccFromApproveId}-#{approve.type}"
			count = FlowversionAPI.traceCounter[countKey]
			if count
				FlowversionAPI.traceCounter[countKey] = count + 1
				# if count > 3 and !approve.cc_users
				if count > 3 and !FlowversionAPI.getToApproveCount(trace, approve._id)
					return
			else
				FlowversionAPI.traceCounter[countKey] = 1

			typeName = ""
			switch approve.type
				when 'cc'
					typeName = "传阅"
				when 'forward'
					typeName = "转发"
				when 'distribute'
					typeName = "分发"
			# 是传阅、分发、转发，则从from_approve_id连接过来
			# 且from_approve_id肯定是当前trace中的approve_id，需要查找到并给定正确的名称
			ccFromApprove = trace.approves.findPropertyByPK("_id",ccFromApproveId)
			traceName = FlowversionAPI.getTraceName trace, ccFromApprove
			if ccFromApprove and ["cc","forward","distribute"].indexOf(ccFromApprove.type) >= 0
				nodes.push "	#{ccFromApproveId}>\"#{traceName}\"]--#{typeName}-->#{approve._id}>\"#{approve.handler_name}\"]"
			else
				nodes.push "	#{ccFromApproveId}(\"#{traceName}\")--#{typeName}-->#{approve._id}>\"#{approve.handler_name}\"]"

	getApproveHandlerNamesWithType: (counter)->


	getTraceCountersWithType_Old: (trace)->
		traceCounters = []
		approves = trace.approves
		traceMaxApproveCount = FlowversionAPI.traceMaxApproveCount

		approves.forEach (fromApprove)->
			fromApproveType = fromApprove.type
			fromApproveId = fromApprove._id
			fromApproveHandlerName = fromApprove.handler_name
			approves.forEach (toApprove)->
				if toApprove.from_approve_id == fromApproveId
					counter = traceCounters.findPropertyByPK("from_approve_id", fromApproveId)
					unless counter
						isEmpty = true
						counter = {}
					counter.from_type = fromApproveType
					counter.to_type = toApprove.type
					counter.from_approve_id = fromApproveId
					counter.to_approve_id = toApprove._id
					counter.from_approve_handler_name = fromApproveHandlerName
					if counter.count
						counter.count++
					else
						counter.count = 1
					unless counter.to_approve_handler_names
						counter.to_approve_handler_names = []
					unless counter.count > traceMaxApproveCount
						counter.to_approve_handler_names.push toApprove.handler_name
				if isEmpty
					traceCounters.push counter
		return traceCounters
	
	getTraceFromApproveCountersWithType: (trace)->
		# 该函数生成json结构，表现出所有传阅、分发、转发节点有有后续子节点的计数情况，其结构为：
		# counters = {
		# 	[fromApproveId(来源节点ID)]:{
		# 		[toApproveType(目标结点类型)]:目标节点在指定类型下的后续节点个数
		# 	}
		# }
		counters = {}
		approves = trace.approves
		unless approves
			return null
		approves.forEach (approve)->
			if approve.from_approve_id
				unless counters[approve.from_approve_id]
					counters[approve.from_approve_id] = {}
				if counters[approve.from_approve_id][approve.type]
					counters[approve.from_approve_id][approve.type]++
				else
					counters[approve.from_approve_id][approve.type] = 1
		return counters

	getTraceCountersWithType: (trace, traceFromApproveCounters)->
		# 该函数生成json结构，表现出所有传阅、分发、转发的节点流向，其结构为：
		# counters = {
		# 	[fromApproveId(来源节点ID)]:{
		# 		[toApproveType(目标结点类型)]:[{
		# 			from_type: 来源节点类型
		# 			from_approve_handler_name: 来源节点处理人
		# 			to_approve_id: 目标节点ID
		# 			to_approve_handler_names: [多个目标节点汇总处理人集合]
		# 			is_total: true/false，是否汇总节点
		# 		},...]
		# 	}
		# }
		# 上述目标结点内容中有一个属性is_total表示是否汇总节点，如果是，则把多个节点汇总合并成一个，
		# 但是本身有后续子节点的节点不参与汇总及计数。
		counters = {}
		approves = trace.approves
		unless approves
			return null
		traceMaxApproveCount = FlowversionAPI.traceMaxApproveCount
		isExpandApprove = FlowversionAPI.isExpandApprove

		approves.forEach (toApprove)->
			toApproveType = toApprove.type
			toApproveFromId = toApprove.from_approve_id
			toApproveHandlerName = toApprove.handler_name
			unless toApproveFromId
				return
			approves.forEach (fromApprove)->
				if fromApprove._id == toApproveFromId
					counter = counters[toApproveFromId]
					unless counter
						counter = counters[toApproveFromId] = {}
					unless counter[toApprove.type]
						counter[toApprove.type] = []
					counter2 = counter[toApprove.type]
					if traceFromApproveCounters[toApprove._id]?[toApproveType]
						# 有后续子节点，则不参与汇总及计数
						counter2.push
							from_type: fromApprove.type
							from_approve_handler_name: fromApprove.handler_name
							to_approve_id: toApprove._id
							to_approve_handler_name: toApprove.handler_name

					else
						counterContent = if isExpandApprove then null else counter2.findPropertyByPK("is_total", true)
						# counterContent = counter2.findPropertyByPK("is_total", true)
						# 如果强制要求展开所有节点，则不做汇总处理
						if counterContent
							counterContent.count++
							unless counterContent.count > traceMaxApproveCount
								counterContent.to_approve_handler_names.push toApprove.handler_name
						else
							counter2.push
								from_type: fromApprove.type
								from_approve_handler_name: fromApprove.handler_name
								to_approve_id: toApprove._id
								count: 1
								to_approve_handler_names: [toApprove.handler_name]
								is_total: true


							# if counter2.count
							# 	counter2.count++
							# else
							# 	counter2.count = 1
							# unless counter2.to_approve_handler_names
							# 	counter2.to_approve_handler_names = []
							# unless counter2.count > traceMaxApproveCount
							# 	counter2.to_approve_handler_names.push toApprove.handler_name

		# 上面traceMaxApproveCount逻辑结果规则是每个fromApprove的每个type分支只有一个节点
		# 这会造成部分后面有二次传阅、分发、转发的节点游离在其来源节点之外，需要单独处理
		# for fromApproveId,fromApprove of counters

		return counters

	getTraceCountersWithType_Old2: (trace)->
		counters = {}
		approves = trace.approves
		traceMaxApproveCount = FlowversionAPI.traceMaxApproveCount
		traceFromApproveCounters = FlowversionAPI.getTraceFromApproveCountersWithType trace

		approves.forEach (fromApprove)->
			fromApproveType = fromApprove.type
			fromApproveId = fromApprove._id
			fromApproveHandlerName = fromApprove.handler_name
			approves.forEach (toApprove)->
				if toApprove.from_approve_id == fromApproveId
					# counter = counters.findPropertyByPK("from_approve_id", fromApproveId)
					counter = counters[fromApproveId]
					unless counter
						counter = counters[fromApproveId] = {}
					unless counter[toApprove.type]
						counter[toApprove.type] = {}
					# unless counter[toApprove.type][toApprove._id]
					# 	counter[toApprove.type][toApprove._id] = {}
					# counter2 = counter[toApprove.type][toApprove._id]
					counter2 = counter[toApprove.type]
					counter2.to_approve_id = toApprove._id
					counter2.from_type = fromApproveType
					counter2.from_approve_handler_name = fromApproveHandlerName
					
					if counter2.count
						counter2.count++
					else
						counter2.count = 1
					unless counter2.to_approve_handler_names
						counter2.to_approve_handler_names = []
					unless counter2.count > traceMaxApproveCount
						counter2.to_approve_handler_names.push toApprove.handler_name
		# 上面traceMaxApproveCount逻辑结果规则是每个fromApprove的每个type分支只有一个节点
		# 这会造成部分后面有二次传阅、分发、转发的节点游离在其来源节点之外，需要单独处理
		# for fromApproveId,fromApprove of counters

		return counters

	pushApprovesWithTypeGraphSyntax: (nodes, trace)->
		traceFromApproveCounters = FlowversionAPI.getTraceFromApproveCountersWithType trace
		traceCounters = FlowversionAPI.getTraceCountersWithType trace, traceFromApproveCounters
		unless traceCounters
			return
		extraHandlerNamesCounter = {} #记录需要额外生成所有处理人姓名的被传阅、分发、转发节点
		traceMaxApproveCount = FlowversionAPI.traceMaxApproveCount
		for fromApproveId,fromApprove of traceCounters
			for toApproveType,toApproves of fromApprove
				toApproves.forEach (toApprove)->
					typeName = ""
					switch toApproveType
						when 'cc'
							typeName = "传阅"
						when 'forward'
							typeName = "转发"
						when 'distribute'
							typeName = "分发"
					traceName = FlowversionAPI.getTraceName2 trace.name, toApprove.from_approve_handler_name
					if toApprove.is_total
						toHandlerNames = toApprove.to_approve_handler_names.join(",")
						extraCount = toApprove.count - traceMaxApproveCount
						if extraCount > 0
							toHandlerNames += "等#{toApprove.count}人"
							unless extraHandlerNamesCounter[fromApproveId]
								extraHandlerNamesCounter[fromApproveId] = {}
							extraHandlerNamesCounter[fromApproveId][toApproveType] = toApprove.to_approve_id
					else
						toHandlerNames = toApprove.to_approve_handler_name
					if ["cc","forward","distribute"].indexOf(toApprove.from_type) >= 0
						nodes.push "	#{fromApproveId}>\"#{traceName}\"]--#{typeName}-->#{toApprove.to_approve_id}>\"#{toHandlerNames}\"]"
					else
						nodes.push "	#{fromApproveId}(\"#{traceName}\")--#{typeName}-->#{toApprove.to_approve_id}>\"#{toHandlerNames}\"]"

		approves = trace.approves
		# extraHandlerNamesCounter的结构为：
		# counters = {
		# 	[fromApproveId(来源节点ID)]:{
		# 		[toApproveType(目标结点类型)]:目标结点ID
		# 	}
		# }
		unless _.isEmpty(extraHandlerNamesCounter)
			for fromApproveId,fromApprove of extraHandlerNamesCounter
				for toApproveType,toApproveId of fromApprove
					tempHandlerNames = []
					approves.forEach (approve)->
						if fromApproveId == approve.from_approve_id
							unless traceFromApproveCounters[approve._id]?[toApproveType]
								# 有后续子节点，则不参与汇总及计数
								tempHandlerNames.push approve.handler_name
					nodes.push "	click #{toApproveId} callback \"#{tempHandlerNames.join(",")}\""



		# traceCounters.forEach (counter)->
		# 	typeName = ""
		# 	switch counter.to_type
		# 		when 'cc'
		# 			typeName = "传阅"
		# 		when 'forward'
		# 			typeName = "转发"
		# 		when 'distribute'
		# 			typeName = "分发"
		# 	traceName = FlowversionAPI.getTraceName2 trace.name, counter.from_approve_handler_name
		# 	toHandlerNames = counter.to_approve_handler_names.join(",")
		# 	extraCount = counter.count - traceMaxApproveCount
		# 	if extraCount > 0
		# 		toHandlerNames += "等#{counter.count}人"
		# 	if ["cc","forward","distribute"].indexOf(counter.from_type) >= 0
		# 		nodes.push "	#{counter.from_approve_id}>\"#{traceName}\"]--#{typeName}-->#{counter.to_approve_id}>\"#{toHandlerNames}\"]"
		# 	else
		# 		nodes.push "	#{counter.from_approve_id}(\"#{traceName}\")--#{typeName}-->#{counter.to_approve_id}>\"#{toHandlerNames}\"]"

	pushApprovesWithTypeGraphSyntax_OLD: (nodes, trace)->
		traceMaxApproveCount = FlowversionAPI.traceMaxApproveCount
		traceCounters = FlowversionAPI.getTraceCountersWithType trace
		traceCounters.forEach (counter)->
			typeName = ""
			switch counter.to_type
				when 'cc'
					typeName = "传阅"
				when 'forward'
					typeName = "转发"
				when 'distribute'
					typeName = "分发"
			traceName = FlowversionAPI.getTraceName2 trace.name, counter.from_approve_handler_name
			toHandlerNames = counter.to_approve_handler_names.join(",")
			extraCount = counter.count - traceMaxApproveCount
			if extraCount > 0
				toHandlerNames += "等#{counter.count}人"
			if ["cc","forward","distribute"].indexOf(counter.from_type) >= 0
				nodes.push "	#{counter.from_approve_id}>\"#{traceName}\"]--#{typeName}-->#{counter.to_approve_id}>\"#{toHandlerNames}\"]"
			else
				nodes.push "	#{counter.from_approve_id}(\"#{traceName}\")--#{typeName}-->#{counter.to_approve_id}>\"#{toHandlerNames}\"]"


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
		lastTrace = null
		lastApproves = []
		traces.forEach (trace)->
			lines = trace.previous_trace_ids
			if lines?.length
				lines.forEach (line)->
					fromTrace = traces.findPropertyByPK("_id",line)
					fromApproves = fromTrace.approves
					toApproves = trace.approves
					lastTrace = trace
					lastApproves = toApproves
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
						# FlowversionAPI.pushCCApproveGraphSyntax nodes, fromTrace, fromApprove
			else
				# 第一个trace，因traces可能只有一个，这时需要单独显示出来
				trace.approves.forEach (approve)->
					traceName = FlowversionAPI.getTraceName trace, approve
					nodes.push "	#{approve._id}(\"#{traceName}\")"

			# FlowversionAPI.traceCounter = {}
			FlowversionAPI.pushApprovesWithTypeGraphSyntax nodes, trace

		# 签批历程中最后的approves中有可能存在传阅、分发、转发，所以需要单独判断并处理下
		# 签批历程中最后的approves高亮显示，结束步骤的trace中是没有approves的，所以结束步骤不高亮显示
		lastApproves?.forEach (lastApprove)->
			FlowversionAPI.pushCCApproveGraphSyntax nodes, lastTrace, lastApprove
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
		FlowversionAPI.isExpandApprove = false
		if type == "traces_expand"
			type = "traces"
			FlowversionAPI.isExpandApprove = true
		switch type
			when 'traces'
				instance = db.instances.findOne instance_id,{fields:{traces: 1}}
				if instance
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
						#flow-steps-svg .node rect{
							fill: #ccccff;
							stroke: rgb(144, 144, 255);
    						stroke-width: 2px;
						}
						#flow-steps-svg .node.current-step-node rect{
							fill: #cde498;
							stroke: #13540c;
							stroke-width: 2px;
						}
						#flow-steps-svg .node.condition rect{
							fill: #ececff;
							stroke: rgb(204, 204, 255);
    						stroke-width: 1px;
						}
						#flow-steps-svg .node .trace-handler-name{
							color: #777;
						}
						div.mermaidTooltip{
							position: fixed!important;
							text-align: left!important;
							padding: 4px!important;
							font-size: 14px!important;
							max-width: 500px!important;
							left: auto!important;
							top: 15px!important;
							right: 15px;
						}
						.btn-zoom{
							background: rgba(0, 0, 0, 0.1);
							border-color: transparent;
							display: inline-block;
							padding: 2px 10px;
							font-size: 26px;
							border-radius: 8px;
							background: #eee;
							color: #777;
							position: fixed;
							bottom: 15px;
							outline: none;
							cursor: pointer;
							z-index: 99999;
						}
						.btn-zoom:hover{
							background: rgba(0, 0, 0, 0.2);
						}
						.btn-zoom-up{
							left: 15px;
						}
						.btn-zoom-down{
							left: 55px;
							padding: 1px 12px 3px 12px;
						}
					</style>
				</head>
				<body>
					<div class = "loading">Loading...</div>
					<div class = "error-msg">#{error_msg}</div>
					<div class="mermaid"></div>
					<script type="text/javascript">
						mermaid.initialize({
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

							var id = "flow-steps-svg";
							var element = $('.mermaid');
							var insertSvg = function(svgCode, bindFunctions) {
								element.html(svgCode);
								if(typeof callback !== 'undefined'){
									callback(id);
								}
								bindFunctions(element[0]);
							};
							mermaid.render(id, graphSyntax, insertSvg, element[0]);

							var zoomSVG = function(zoom){
								var currentWidth = $("svg").width();
								var newWidth = currentWidth * zoom;
								$("svg").css("maxWidth",newWidth + "px").width(newWidth);
							}

							//支持鼠标滚轮缩放画布
							$(window).on("mousewheel",function(event){
								if(event.ctrlKey){
									event.preventDefault();
									var zoom = event.originalEvent.wheelDelta > 0 ? 1.1 : 0.9;
									zoomSVG(zoom);
								}
							});
							$(".btn-zoom").on("click",function(){
								zoomSVG($(this).attr("zoom"));
							});
						});
					</script>
					<a class="btn-zoom btn-zoom-up" zoom=1.1 title="点击放大">+</a>
					<a class="btn-zoom btn-zoom-down" zoom=0.9 title="点击缩小">-</a>
				</body>
			</html>
		"""

JsonRoutes.add 'get', '/api/workflow/chart?instance_id=:instance_id', (req, res, next) ->
	# 流程图
	FlowversionAPI.sendHtmlResponse req, res

JsonRoutes.add 'get', '/api/workflow/chart/traces?instance_id=:instance_id', (req, res, next) ->
	# 汇总签批历程图
	FlowversionAPI.sendHtmlResponse req, res, "traces"

JsonRoutes.add 'get', '/api/workflow/chart/traces_expand?instance_id=:instance_id', (req, res, next) ->
	# 展开所有节点的签批历程图
	FlowversionAPI.sendHtmlResponse req, res, "traces_expand"

