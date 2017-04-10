Template.flow_steps_modal.helpers
	stepsSvg: ->
		stepsScript = 'graph LR\n我我-->你\n你-->c\n我-->c';
		return mermaidAPI.render('flow-steps-svg', stepsScript);
	steps: ->
		# // debugger;
		# // return [{name:"step1"},{name:"step2"},{name:"step3"},{name:"step4"},{name:"step5"},{name:"step6"}]
		# // var processView = WorkflowManager.getInstanceFlowVersion();
		# // var steps = processView.steps;
		# // var dealTypeName = "";
		# // return steps.map(function(step){
			
		# // 	var lines = step.lines;
		# // 	var nextStepNames = "";
		# // 	// if(lines){
		# // 	// 	nextStepNames = lines.getProperty("to_step").join(",");
		# // 	// } 
		# // 	// debugger;
		# // 	if(lines){
		# // 		nextStepNames = lines.map(function(line){
		# // 			var to_step = line.to_step;
		# // 			return steps.findPropertyByPK("_id",to_step).name;
		# // 		})
		# // 	}
			
		# // 	switch(step.deal_type) {
		# // 		case 'pickupAtRuntime': 
		# // 			dealTypeName =  '审批时指定人员';
		# // 			break;
		# // 		case 'specifyUser':
		# // 			dealTypeName =  '指定人员';
		# // 			break;
		# // 		case 'applicantRole':
		# // 			dealTypeName =  '指定审批岗位';
		# // 			break;
		# // 		case 'applicantSuperior':
		# // 			dealTypeName =  '申请人上级';
		# // 			break;
		# // 		case 'applicant':
		# // 			dealTypeName =  '申请人';
		# // 			break;
		# // 		case 'orgField':
		# // 			dealTypeName =  '指定部门';
		# // 			break;
		# // 		default:
		# // 			break;
		# // 	}
		# // 	return {
		# // 		name:step.name,
		# // 		dealTypeName: dealTypeName,
		# // 		nextStepNames: nextStepNames
		# // 	};
		# // });
	# // nextStepNames: function(step){
	# // 	return step.lines.getProperty("to_step").join(",")

	# // }

Template.flow_steps_modal.events

Template.flow_steps_modal.onRendered ->
	# $(".ins-flow_steps_modal-modal .modal-body").css("max-height", Steedos.getModalMaxHeight());
