Template.forward_select_flow_modal.helpers({
	fields: function() {
		return new SimpleSchema({
			forward_users: {
				autoform: {
					type: "selectuser",
					multiple: true,
					spaceId: Session.get("forward_space_id")
				},
				optional: true,
				type: [String],
				label: TAPi18n.__("instance_forward_users")
			}
		})
	},

	values: function() {
		return {}
	},

	// 本工作去或者未设置禁止转发（step.disableForward=true）才能转发给工作区下其他用户，否则只能转发给自己
	is_show_selectuser: function() {
		if (Session.get('forward_space_id') == Session.get('spaceId')) {
			if (InstanceManager.isInbox()) {
				var cs = InstanceManager.getCurrentStep();
				if (cs && (cs.disableForward != true))
					return true;
			}
		}
		return false;
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
		var flow = $("#forward_flow")[0].dataset.flow;

		if (!flow)
			return;

		var selectedUsers = AutoForm.getFieldValue("forward_users", "forward_select_user");

		if ((Session.get('forward_space_id') != Session.get('spaceId')) || Session.get("box") != "inbox") {
			selectedUsers = [Meteor.userId()];
		}

		if (_.isEmpty(selectedUsers)) {
			toastr.error(TAPi18n.__("instance_forward_error_users_required"));
			return;
		}

		InstanceManager.forwardIns(Session.get('instanceId'), Session.get('forward_space_id'), flow, $("#saveInstanceToAttachment")[0].checked, $("#forward_flow_text").val(), $("#isForwardAttachments")[0].checked, selectedUsers);
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