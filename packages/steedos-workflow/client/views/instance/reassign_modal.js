Template.reassign_modal.helpers({

    fields: function() {
        return new SimpleSchema({
            reassign_users: {
                autoform: {
                    type: "selectuser"
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
        window.open(t("reassign_help"));
    },

    'click #reassign_modal_ok': function(event, template) {
        var val = AutoForm.getFieldValue("reassign_users", "reassign");
        if (!val) {
            toastr.error(TAPi18n.__("instance_reassign_error_users_required"));
            return;
        }

        var reason = $("#reassign_modal_text").val();
        if (!reason) {
            toastr.error(TAPi18n.__("instance_reassign_error_reason_required"));
            return;
        }

        var user_ids = val.split(",");

        InstanceManager.reassignIns(user_ids, reason);

        Modal.hide(template);
    },


})
