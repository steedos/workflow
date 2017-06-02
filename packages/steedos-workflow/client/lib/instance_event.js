InstanceEvent = {};

InstanceEvent.before = {}


function getFlowEvent(flowId) {
	var flow = WorkflowManager.getFlow(flowId);
	if(flow){
		return flow.events;
	}
}

InstanceEvent.initEvents = function(flowId) {

	var eventStr = getFlowEvent(flowId);
	if(eventStr){
		try {
			eval(eventStr);
		} catch (e) {

			toastr.error(TAPi18n.__("flows_events_error") + e);

			console.error('flow Event Error: ' + e);
		}
	}
}

/*
 * return true：继续执行; false 中断后续操作
 *  "instance-before-submit" / "instance-before-upload"
 */
InstanceEvent.run = function (element, eventName) {
	var ins = WorkflowManager.getInstance();

	if(!ins)
		return true;

	var eventStr = getFlowEvent(ins.flow);

	if(!eventStr)
		return true;

	var event = jQuery.Event(eventName, {
		// instance: instance
	});

	element.trigger(event);

	return !event.isDefaultPrevented();
}

/*
* return true：继续执行; false 中断后续操作
*/
InstanceEvent.before.instanceSubmit = function() {
	var ins = WorkflowManager.getInstance();

	if(!ins)
		return true;

	var eventStr = getFlowEvent(ins.flow);

	if(!eventStr)
		return true;

	var event = jQuery.Event("instance-before-submit", {
		// instance: instance
	});

	$(".instance-form").trigger(event);

	return !event.isDefaultPrevented();
}