
Template.instance_trace_detail_modal.helpers(TracesTemplate.helpers);

Template.instance_trace_detail_modal.events(TracesTemplate.events)

Template.instance_trace_detail_modal.onRendered(function () {
	if(!Steedos.isMobile()){
		debugger
		// // $("#finish_input").datetimepicker({
		// // 	format: "yyyy-MM-dd HH:mm"
		// // });
		// this.autorun(function(){
		// 	if(this.is_editing.get()){
		// 		debugger
		// 		$("#instance_trace_detail_modal #finish_input").datetimepicker({
		// 			format: "yyyy-MM-dd HH:mm",
		// 			widgetPositioning:{
		// 				horizontal: 'right'
		// 			}
		// 		});
		// 	}
		// });
	}
	$(".instance-trace-detail-modal .modal-body").css("max-height", Steedos.getModalMaxHeight());
})
Template.instance_trace_detail_modal.onCreated(function () {
	this.is_editing = new ReactiveVar(false);
})