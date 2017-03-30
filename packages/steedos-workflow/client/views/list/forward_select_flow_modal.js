Template.forward_select_flow_modal.helpers({
	fields: function() {
		return new SimpleSchema({
			forward_users: {
				autoform: {
					type: "selectuser",
					multiple: true
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

	// 跨工作区只能转发给自己
	is_show_selectuser: function() {
		if (Session.get('forward_space_id') != Session.get('spaceId')) {
			return false;
		}
		return true;
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

		if (Session.get('forward_space_id') != Session.get('spaceId')) {
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