Template.flow_steps_modal.helpers
	stepsSvg: ->
		# 该函数返回以下格式的graph脚本
		# graphScript = '''
		# 	graph LR
		# 		A-->B
		# 		A-->C
		# 		B-->C
		# 		C-->A
		# 		D-->C
		# 	'''
		steps = WorkflowManager.getInstanceFlowVersion()?.steps
		nodes = ["graph LR"]
		steps.forEach (step)->
			lines = step.lines
			if lines?.length
				lines.forEach (line)->
					toStepName = steps.findPropertyByPK("_id",line.to_step).name
					dealTypeName = WorkflowManager.getStepDealTypeName step
					nodes.push "	#{step._id}(<div class='graph-node'><div class='step-name'>#{step.name}</div></div>)-->#{line.to_step}(#{toStepName})"

		graphScript = nodes.join "\n"
		return mermaidAPI.render('flow-steps-svg', graphScript)

Template.flow_steps_modal.events

Template.flow_steps_modal.onRendered ->
	$(".ins-flow-steps-modal .modal-body").css("max-height", Steedos.getModalMaxHeight());
