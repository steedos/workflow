
Template.instance_traces.helpers(TracesTemplate.helpers);

Template.instance_traces.events(TracesTemplate.events)

Template.instance_traces.onCreated(function () {
	self = this;
	myApprove = InstanceManager.getCurrentApprove()
	self.myApprove = new ReactiveVar(myApprove);
})