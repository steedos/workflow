Template.flow_steps_modal.helpers({
	steps: function(){
		// debugger;
		// return [{name:"step1"},{name:"step2"},{name:"step3"},{name:"step4"},{name:"step5"},{name:"step6"}]
		var processView = WorkflowManager.getInstanceFlowVersion();
		var steps = processView.steps;
		var dealTypeName = "";
		switch(steps.deal_type) {
			case '审批时指定人员': 
				dealTypeName =  "审批时指定人员"
				break;
			case '指定人员':
				dealTypeName =  "指定人员"
				break;
			case '指定审批岗位':
				dealTypeName =  "指定审批岗位"
				break;
			case '申请人上级':
				dealTypeName =  "申请人上级"
				break;
			case '申请人':
				dealTypeName =  "申请人"
				break;
			case '指定部门':
				dealTypeName =  "指定部门"
				break;
			default:
				break;
		}
		return steps.map(function(step){
			return {
				name:step.name,
				dealTypeName: dealTypeName,
				lines:step.lines
			}
		});
	}
	
})

Template.flow_steps_modal.events({
})

Template.flow_steps_modal.onRendered(function(){
	// $(".ins-flow_steps_modal-modal .modal-body").css("max-height", Steedos.getModalMaxHeight());
});