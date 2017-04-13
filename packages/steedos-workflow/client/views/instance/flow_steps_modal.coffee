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
					if step.name
						# 把特殊字符清空或替换，以避免mermaidAPI出现异常
						stepName = step.name.replace(/[\r\n]/g,"").replace(/[？]/g,"?")
					else
						stepName = ""
					toStepName = steps.findPropertyByPK("_id",line.to_step).name
					toStepName = toStepName.replace(/[\r\n]/g,"").replace(/[？]/g,"?")
					nodes.push "	#{step._id}(<div class='graph-node'><div class='step-name'>#{stepName}</div></div>)-->#{line.to_step}(#{toStepName})"

		graphScript = nodes.join "\n"
		return mermaidAPI.render('flow-steps-svg', graphScript)

Template.flow_steps_modal.events

Template.flow_steps_modal.onRendered ->
	$(".ins-flow-steps-modal .modal-body").css("max-height", Steedos.getModalMaxHeight());
