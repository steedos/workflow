Template.forward_select_flow_modal.helpers({
	title: function() {
		if (this.action_type == "forward") {
			return TAPi18n.__('instance_forward_title');
		} else if (this.action_type == "distribute") {
			return TAPi18n.__('instance_distribute_title');
		}
	},

	note: function() {
		if (this.action_type == "forward") {
			return TAPi18n.__('instanceForwardNote');
		} else if (this.action_type == "distribute") {
			return TAPi18n.__('instance_distribute_note');
		}
	},

	take_attachments: function() {
		if (this.action_type == "forward") {
			return TAPi18n.__('isForwardAttachments');
		} else if (this.action_type == "distribute") {
			return TAPi18n.__('instance_distribute_attachments');
		}
	},

	fields: function() {
		var users_title = "";
		if (this.action_type == "forward") {
			users_title = TAPi18n.__('instance_forward_users');
		} else if (this.action_type == "distribute") {
			users_title = TAPi18n.__('instance_distribute_users');
		};
		return new SimpleSchema({
			forward_users: {
				autoform: {
					type: "selectuser",
					multiple: true,
					spaceId: Session.get('forward_space_id')
				},
				optional: true,
				type: [String],
				label: users_title
			}
		})
	},

	values: function() {
		return {}
	},

	// 判断是转发还是分发
	is_show_selectuser: function() {
		if (this.action_type == "forward") {
			return false;
		} else if (this.action_type == "distribute") {
			if (InstanceManager.isInbox()) {
				var cs = InstanceManager.getCurrentStep();
				if (cs && (cs.allowDistribute == true))
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
		var action_type = template.data.action_type;
		if (action_type == "forward") {
			Steedos.openWindow(t("forward_help"));
		} else if (action_type == "distribute") {
			Steedos.openWindow(t("forward_help"));
		}

	},

	'click #forward_flow_ok': function(event, template) {
		var action_type = template.data.action_type;
		var flow = $("#forward_flow")[0].dataset.flow;

		if (!flow)
			return;

		var selectedUsers = AutoForm.getFieldValue("forward_users", "forward_select_user");

		if (action_type == 'forward') {
			selectedUsers = [Meteor.userId()];
		}

		if (_.isEmpty(selectedUsers)) {
			toastr.error(TAPi18n.__("instance_forward_error_users_required"));
			return;
		}

		InstanceManager.forwardIns(Session.get('instanceId'), Session.get('forward_space_id'), flow, $("#saveInstanceToAttachment")[0].checked, $("#forward_flow_text").val(), $("#isForwardAttachments")[0].checked, selectedUsers, action_type);
		Modal.hide(template);
	},

	'click #forward_flow': function(event, template) {
		Modal.allowMultiple = true;
		Modal.show("selectFlowModal", {
			onSelectFlow: function(flow) {
				$("#forward_flow")[0].dataset.flow = flow._id;
				$("#forward_flow").val(flow.name);

				if (Session.get('forward_space_id') != flow.space) {
					AutoForm.resetForm("forward_select_user");
					Session.set('forward_space_id', flow.space);
				}
			},
			action_type: template.data.action_type
		});
	}

})