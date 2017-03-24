Template.forward_select_flow_modal.helpers({
	flow_list_data: function() {
		if (!Steedos.subsForwardRelated.ready()) {
			return;
		}

		return WorkflowManager.getFlowListData('forward');
	},

	empty: function(categorie) {
		if (!categorie.forms || categorie.forms.length < 1)
			return false;
		return true;
	},

	equals: function(a, b) {
		return a == b;
	},

	spaces: function() {
		return db.spaces.find();
	},

	spaceName: function() {
		if (Session.get('forward_space_id')) {
			space = db.spaces.findOne(Session.get("forward_space_id"))
			if (space)
				return space.name
		}

		return t("Steedos")
	}

})

Template.forward_select_flow_modal.onRendered(function() {
	if (!Session.get('forward_space_id') && Session.get('spaceId')) {
		Session.set('forward_space_id', Session.get('spaceId'));
	}
})


Template.forward_select_flow_modal.events({
	'click #forward_help': function(event, template) {
		Steedos.openWindow(t("forward_help"));
	},

	'click #forward_flow_ok': function(event, template) {
		flow = $("#forward_flow")[0].dataset.flow;


		if (!flow)
			return;

		InstanceManager.forwardIns(Session.get('instanceId'), Session.get('forward_space_id'), flow, $("#saveInstanceToAttachment")[0].checked, $("#forward_flow_text").val(), $("#isForwardAttachments")[0].checked);
		Modal.hide(template);
	},

	'click #forward_flow': function(event, tempalte) {
		Modal.allowMultiple = true;
		Modal.show("selectFlowModal", {
			onSelectFlow: function(flow) {
				$("#forward_flow")[0].dataset.flow = flow._id;
				$("#forward_flow").val(flow.name);
			}
		});
	}

})