Template.instance_traces_table.helpers(TracesTemplate.helpers);

Template.instance_traces_table.events(TracesTemplate.events)

Template.instance_traces_table.onRendered(function () {
    if (!Session.get("instancePrint")) {
        $("#tracesCollapse").parent().hide()
    }
})


Template.instance_traces_table.onCreated(function () {
	self = this;
	myApprove = InstanceManager.getCurrentApprove()
	self.myApprove = new ReactiveVar(myApprove);
})
