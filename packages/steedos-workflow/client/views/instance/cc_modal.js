Template.instance_cc_modal.helpers({

    fields: function() {
        return new SimpleSchema({
            cc_users: {
                autoform: {
                    type: "selectuser",
                    multiple: true
                },
                optional: true,
                type: [String],
                label: TAPi18n.__("instance_cc_user")
            }
        });
    },

    values: function() {
        return {};
    }
})


Template.instance_cc_modal.events({

    'show.bs.modal #instance_cc_modal': function(event) {

        var cc_users = $("input[name='cc_users']", $("#instance_cc_modal"))[0];

        cc_users.value = "";
        cc_users.dataset.values = '';

        var s = InstanceManager.getCurrentStep();

        $("#instance_curstepName", $("#instance_cc_modal")).html(s.name);
    },

    'click #cc_modal_ok': function(event, template) {

        var val = AutoForm.getFieldValue("cc_users", "instanceCCForm");

        if (!val || val.length < 1) {
            toastr.error(TAPi18n.__("instance_cc_error_users_required"));
            return;
        }

        InstanceManager.saveIns();

        //调用cc 接口。
        var instance = WorkflowManager.getInstance();
        var myApprove;

        if (InstanceManager.isCC(instance)) {
            myApprove = InstanceManager.getCCApprove(Meteor.userId(), false);
        } else {
            myApprove = InstanceManager.getMyApprove();
            myApprove.values = InstanceManager.getInstanceValuesByAutoForm();
            if (instance.attachments && myApprove) {
                myApprove.attachments = instance.attachments;
            }
        }

        Meteor.call('cc_do', myApprove, val, function(error, result) {
            WorkflowManager.instanceModified.set(false);

            if (error) {
                Modal.hide(template);
                toastr.error("error");
            };

            if (result == true) {
                toastr.success(t("instance_cc_done"));

                Modal.hide(template);
                WorkflowManager.callInstanceDataMethod(Session.get('instanceId'), function() {
                    Session.set("change_date", new Date().getTime())
                });
            }
        });


    },


})