Template.reassign_modal.helpers({

    fields: function() {

        var userOptions = null;

        var showOrg = true;

		var instance = WorkflowManager.getInstance();

		var space = db.spaces.findOne(instance.space);

        var flow = db.flows.findOne({'_id': instance.flow});

		var curSpaceUser = db.space_users.findOne({space: instance.space, 'user': Meteor.userId()});

		var organizations = db.organizations.find({_id: {$in: curSpaceUser.organizations}}).fetch();
		if(space.admins.contains(Meteor.userId())){

		}else if(WorkflowManager.canAdmin(flow, curSpaceUser, organizations)){
			var currentStep = InstanceManager.getCurrentStep()

			userOptions = ApproveManager.getNextStepUsers(instance, currentStep._id).getProperty("id").join(",")

			showOrg = Session.get("next_step_users_showOrg")
        }else{
			userOptions = "0"
			showOrg = false
        }

        console.log("userOptions", userOptions)
		console.log("showOrg", showOrg)

        return new SimpleSchema({
            reassign_users: {
                autoform: {
                    type: "selectuser",
					userOptions: userOptions,
					showOrg: showOrg
                },
                optional: true,
                type: String,
                label: TAPi18n.__("instance_reassign_user")
            }
        });
    },

    values: function() {
        return {};
    }
})


Template.reassign_modal.events({

    'show.bs.modal #reassign_modal': function(event) {

        var reassign_users = $("input[name='reassign_users']")[0];

        reassign_users.value = "";
        reassign_users.dataset.values = '';

        $("#reassign_modal_text").val(null);

        var s = InstanceManager.getCurrentStep();

        $("#reassign_currentStepName").html(s.name);

        if (s.step_type == "counterSign") {
            reassign_users.dataset.multiple = true;
        } else {
            reassign_users.dataset.multiple = false;
        }
    },

    'click #reassign_help': function(event, template) {
        Steedos.openWindow(t("reassign_help"));
    },

    'click #reassign_modal_ok': function(event, template) {
        var val = AutoForm.getFieldValue("reassign_users", "reassign");
        if (!val) {
            toastr.error(TAPi18n.__("instance_reassign_error_users_required"));
            return;
        }

        

        var user_ids = val.split(",");

        InstanceManager.reassignIns(user_ids, reason);

        Modal.hide(template);
    },


})
