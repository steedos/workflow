Template.instance_cc_modal.helpers({

    fields: function () {

        var form_version = WorkflowManager.getInstanceFormVersion();
        var currentStep = InstanceManager.getCurrentStep();

        var currentApprove = InstanceManager.getCurrentApprove();

        var opinionFields = _.filter(form_version.fields, function (field) {
            if(currentApprove.type == "cc"){
                return InstanceformTemplate.helpers.isOpinionField(field) && field.code == currentApprove.opinion_field_code;
            }
            return InstanceformTemplate.helpers.isOpinionField(field) && InstanceformTemplate.helpers.getOpinionFieldStepName(field) == currentStep.name
        });
        var modalFields = {
            cc_users: {
                autoform: {
                    type: "selectuser",
                    multiple: true
                },
                optional: false,
                type: [String],
                label: TAPi18n.__("instance_cc_user")
            }
        }

        if(opinionFields.length > 0){
            modalFields.opinion_field = {
                autoform:{
                    type: "select"
                },
                type: String,
                label: TAPi18n.__("instance_opinion_field")
            }
            var options = new Array();
            opinionFields.forEach(function(field){
                var label = (field.name != null && field.name.length > 0) ? field.name : field.code;
                options.push({label: label, value: field.code})
            });


            modalFields.opinion_field.autoform.options = options

            if(options.length == 1){
                modalFields.opinion_field.autoform.defaultValue = options[0].value;
            }
        }

        return new SimpleSchema(modalFields);
    },

    values: function () {
        return {};
    },

    showOpinionFields: function(fields){
        if(fields.schema("opinion_field")){
            return true;
        }
        return false;
    }
})


Template.instance_cc_modal.events({

    'show.bs.modal #instance_cc_modal': function (event) {

        var cc_users = $("input[name='cc_users']", $("#instance_cc_modal"))[0];

        cc_users.value = "";
        cc_users.dataset.values = '';

        var s = InstanceManager.getCurrentStep();

        $("#instance_curstepName", $("#instance_cc_modal")).html(s.name);
    },

    'click #cc_help': function (event, template) {
        Steedos.openWindow(t("cc_help"));
    },

    'click #cc_modal_ok': function (event, template) {

        var val = AutoForm.getFieldValue("cc_users", "instanceCCForm");

        if (!val || val.length < 1) {
            toastr.error(TAPi18n.__("instance_cc_error_users_required"));
            return;
        }

        var opinion_field_code = AutoForm.getFieldValue("opinion_field", "instanceCCForm");

        if(AutoForm.getFormSchema("instanceCCForm").schema("opinion_field")){
            if (!opinion_field_code || opinion_field_code.length < 1) {
                toastr.error(TAPi18n.__("instance_cc_error_opinion_field_required"));
                return;
            }
        }


        $("#cc_modal_ok").attr("disabled", true)
        $("#cc_modal_ok").html("<i class='ion ion-load-c fa-spin'></i>")

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

        myApprove.opinion_field_code = opinion_field_code;

        Meteor.call('cc_do', myApprove, val, function (error, result) {
            WorkflowManager.instanceModified.set(false);

            if (error) {
                Modal.hide(template);
                toastr.error("error");
            }
            ;

            if (result == true) {
                toastr.success(t("instance_cc_done"));

                Modal.hide(template);
            }
        });


    },


})
