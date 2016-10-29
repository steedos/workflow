Template.instance_button.helpers
    enabled_submit: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        flow = db.flows.findOne(ins.flow);
        if !flow
            return "display: none;";
        if InstanceManager.isInbox()
            return "";
        if !ApproveManager.isReadOnly()
            return "";
        else
            return "display: none;";

    enabled_save: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        flow = db.flows.findOne(ins.flow);
        if !flow
            return "display: none;";
        
        if InstanceManager.isInbox()
            return "";

        if !ApproveManager.isReadOnly()
            return "";
        else
            return "display: none;";

    enabled_delete: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        space = db.spaces.findOne(ins.space);
        if !space
            return "display: none;";
        fl = db.flows.findOne({'_id': ins.flow});
        if !fl
            return "display: none;";
        curSpaceUser = db.space_users.findOne({space: ins.space, 'user': Meteor.userId()});
        if !curSpaceUser
            return "display: none;";
        organizations = db.organizations.find({_id: {$in: curSpaceUser.organizations}}).fetch();
        if !organizations
            return "display: none;";

        if Session.get("box")=="draft" || (Session.get("box")=="monitor" && space.admins.contains(Meteor.userId())) || (Session.get("box")=="monitor" && WorkflowManager.canAdmin(fl, curSpaceUser, organizations))
            return "";
        else
            return "display: none;";

    enabled_print: ->
        # TODO 手机打印
        return "";


    enabled_add_attachment: -> 
        if !ApproveManager.isReadOnly()
            return "";
        else
            return "display: none;";

    enabled_terminate: ->
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        if (Session.get("box")=="pending" || Session.get("box")=="inbox") && ins.state=="pending" && ins.applicant==Meteor.userId()
            return "";
        else
            return "display: none;";

    enabled_reassign: -> 
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        space = db.spaces.findOne(ins.space);
        if !space
            return "display: none;";
        fl = db.flows.findOne({'_id': ins.flow});
        if !fl
            return "display: none;";
        curSpaceUser = db.space_users.findOne({space: ins.space, 'user': Meteor.userId()});
        if !curSpaceUser
            return "display: none;";
        organizations = db.organizations.find({_id: {$in: curSpaceUser.organizations}}).fetch();
        if !organizations
            return "display: none;";

        if Session.get("box")=="monitor" && ins.state=="pending" && (space.admins.contains(Meteor.userId()) || WorkflowManager.canAdmin(fl, curSpaceUser, organizations))
            return "";
        else
            return "display: none;";

    enabled_relocate: -> 
        ins = WorkflowManager.getInstance();
        if !ins
            return "display: none;";
        space = db.spaces.findOne(ins.space);
        if !space
            return "display: none;";
        fl = db.flows.findOne({'_id': ins.flow});
        if !fl
            return "display: none;";
        curSpaceUser = db.space_users.findOne({space: ins.space, 'user': Meteor.userId()});
        if !curSpaceUser
            return "display: none;";
        organizations = db.organizations.find({_id: {$in: curSpaceUser.organizations}}).fetch();
        if !organizations
            return "display: none;";

        if Session.get("box")=="monitor" && ins.state=="pending" && (space.admins.contains(Meteor.userId()) || WorkflowManager.canAdmin(fl, curSpaceUser, organizations))
            return "";
        else
            return "display: none;";

    enabled_cc: ->
        if InstanceManager.isInbox()
            return "";
        else
            return "display: none;";

    enabled_forward: ->
        ins = WorkflowManager.getInstance()
        if !ins
            return "display: none;"

        if ins.state!="draft" && !Steedos.isMobile()
            return ""
        else
            return "display: none;"

Template.instance_button.events
    'click #instance_back': (event)->
        backURL =  "/workflow/space/" + Session.get("spaceId") + "/" + Session.get("box")
        FlowRouter.go(backURL)

    'click #instance_to_print': (event)->
        UUflow_api.print(Session.get("instanceId"));


    'click #instance_update': (event)->
        InstanceManager.saveIns();
        Session.set("instance_change", false);

    'click #instance_remove': (event)->
        swal {   
            title: t("Are you sure?"),    
            type: "warning",   
            showCancelButton: true,  
            cancelButtonText: t('Cancel'), 
            confirmButtonColor: "#DD6B55",   
            confirmButtonText: t('OK'),   
            closeOnConfirm: true 
        }, () ->  
            Session.set("instance_change", false);
            InstanceManager.deleteIns()

    'click #instance_submit': (event)->
        if WorkflowManager.isArrearageSpace()
            ins = WorkflowManager.getInstance();
            if ins.state=="draft"
                toastr.error(t("spaces_isarrearageSpace"));
                return
        if !ApproveManager.isReadOnly()
            InstanceManager.checkFormValue();
        if($(".has-error").length == 0)
            InstanceManager.submitIns();
            Session.set("instance_change", false);

    'click #instance_force_end': (event)->
        swal {
            title: t("instance_cancel_title"), 
            text: t("instance_cancel_reason"), 
            type: "input",
            confirmButtonText: t('OK'),
            cancelButtonText: t('Cancel'),
            showCancelButton: true,
            closeOnConfirm: false
        }, (reason) ->
            # 用户选择取消
            if (reason == false) 
                return false;

            if (reason == "") 
                swal.showInputError(t("instance_cancel_error_reason_required"));
                return false;
            
            InstanceManager.terminateIns(reason);
            sweetAlert.close();

    'click #instance_reassign': (event, template) ->
        Modal.show('reassign_modal')

    'click #instance_relocate': (event, template) ->
        Modal.show('relocate_modal')


    'click #instance_cc': (event, template) ->
        Modal.show('instance_cc_modal');

    'click #instance_forward': (event, template) ->
        #判断是否为欠费工作区
        if WorkflowManager.isArrearageSpace()
            toastr.error(t("spaces_isarrearageSpace"));
            return;

        Modal.show("forward_select_flow_modal")

    