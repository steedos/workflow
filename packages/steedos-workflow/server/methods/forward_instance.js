Meteor.methods({
    forward_instance: function(instance_id, space_id, flow_id) {
        if (!this.userId)
            return;

        check(instance_id, String);
        check(space_id, String);
        check(flow_id, String);

        // TODO check id对应的数据是否存在

        var ins = db.instances.findOne(instance_id);

        var flow = db.flows.findOne(flow_id);

        var user_id = this.userId;
        var user_info = db.users.findOne(user_id);

        var space_user = db.space_users.findOne({
            space: space_id,
            user: user_id
        });
        var space_user_org_info = db.organizations.findOne(space_user.organization);

        var now = new Date();
        var ins_obj = {};

        ins_obj._id = db.instances._makeNewID();
        ins_obj.space = space_id;
        ins_obj.flow = flow_id;
        ins_obj.flow_version = flow.current._id;
        ins_obj.form = flow.form;
        ins_obj.form_version = flow.current.form_version;
        ins_obj.name = flow.name;
        ins_obj.submitter = user_id;
        ins_obj.submitter_name = user_info.name;
        ins_obj.applicant = user_id;
        ins_obj.applicant_name = user_info.name;
        ins_obj.applicant_organization = space_user.organization;
        ins_obj.applicant_organization_name = space_user_org_info.name;
        ins_obj.applicant_organization_fullname = space_user_org_info.fullname;
        ins_obj.state = "draft";
        ins_obj.code = "";
        ins_obj.is_archived = false;
        ins_obj.is_deleted = false;
        ins_obj.created = now;
        ins_obj.created_by = user_id;
        ins_obj.modified = now;
        ins_obj.modified_by = user_id;

        // 新建Trace
        var trace_obj = {};
        trace_obj._id = Meteor.uuid();
        trace_obj.instance = ins_obj._id;
        trace_obj.is_finished = false;

        // 当前最新版flow中开始节点的step_id
        var step_id;
        flow.current.steps.forEach(function(step) {
            if (step.step_type == "start")
                step_id = step._id;
        })
        trace_obj.step = step_id;
        trace_obj.start_date = now;

        // 新建Approve
        var appr_obj = {};
        appr_obj.instance = ins_obj._id;
        appr_obj.trace = trace_obj._id;
        appr_obj.is_finished = false;
        appr_obj.user = user_id;
        appr_obj.user_name = user_info.name;
        appr_obj.handler = user_id;
        appr_obj.handler_name = user_info.name;
        appr_obj.handler_organization = space_user.organization;
        appr_obj.handler_organization_name = space_user_org_info.name;
        appr_obj.handler_organization_fullname = space_user_org_info.fullname;
        appr_obj.type = "draft";
        appr_obj.start_date = now;
        appr_obj.read_date = now;
        appr_obj.is_read = true;
        appr_obj.is_error = false;
        appr_obj.description = "";


        trace_obj.approves = [appr_obj];
        ins_obj.traces = [trace_obj];

        new_ins_id = db.instances.insert(ins_obj);

        return new_ins_id;
    }
})