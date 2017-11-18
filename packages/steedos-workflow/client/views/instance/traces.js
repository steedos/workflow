Template.instance_traces.helpers(TracesTemplate.helpers);

Template.instance_traces.events(TracesTemplate.events)

Template.instance_traces.onCreated(function() {
	self = this;
	myApprove = InstanceManager.getCurrentApprove()
	self.myApprove = new ReactiveVar(myApprove);
})

Template.instance_traces.onRendered(function() {
	var instance_ids = [];
	_.each(this.data, function(t) {
		_.each(t.approves, function(a) {
			if (a.type == 'distribute') {
				instance_ids.push(a.forward_instance)
			}
		})
	})
	if (!_.isEmpty(instance_ids)) {
		Steedos.subs["distributed_instances"].subscribe('distributed_instances_state_by_ids', instance_ids)
	}
})