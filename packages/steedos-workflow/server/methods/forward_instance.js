Meteor.methods({
    forward_instance: function(instance_id, space_id, flow_id) {
        if (!this.userId)
            return;

        check(instance_id, String);
        check(space_id, String);
        check(flow_id, String);

        var ins = db.instances.findOne(instance_id);
        var old_space_id = ins.space;

        var flow = db.flows.findOne(flow_id);

        var space = db.spaces.findOne(space_id);

        if (!ins || !flow || !space) {
            throw new Meteor.Error('params error!', 'record not exists!');
        }

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
        appr_obj._id = Meteor.uuid();
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
        // 计算values
        var old_values = ins.values,
            new_values = {};
        var form = db.forms.findOne(flow.form);
        var fields = form.current.fields || [];

        var old_form = db.forms.findOne(ins.form);
        var old_form_version = ins.form_version,
            old_fields = [],
            common_fields = [];

        if (old_form.current._id == old_form_version) {
            old_fields = old_form.current.fields;
        } else {
            if (old_form.historys) {
                old_form.historys.forEach(function(h) {
                    if (h._id == old_form_version)
                        old_fields = h.fields;
                })
            }
        }

        fields.forEach(function(field) {
            var exists_field = _.find(old_fields, function(f) {
                return f.type == field.type && f.code == field.code;
            })
            if (exists_field)
                common_fields.push(field);
        })

        common_fields.forEach(function(field) {
            if (field.type == 'section') {
                if (field.fields) {
                    field.fields.forEach(function(f) {
                        // 跨工作区转发不复制选人选组
                        if (['group', 'user'].includes(f.type) && old_space_id != space_id) {
                            return;
                        }
                        var key = f.code;
                        var old_v = old_values[key];
                        if (old_v) {
                            // 校验 单选，多选，下拉框 字段值是否在新表单对应字段的可选值范围内
                            if (field.type == 'select' || field.type == 'radio') {
                                var options = field.options.split('\n');
                                if (!options.includes(old_v))
                                    return;
                            }

                            if (field.type == 'multiSelect') {
                                var options = field.options.split('\n');
                                var old_multiSelected = old_v.split(',');
                                var new_multiSelected = _.intersection(options, old_multiSelected);
                                old_v = new_multiSelected.join(',');
                            }

                            new_values[key] = old_v;
                        }
                    })
                }
            } else {
                if (field.type == 'table') {
                    return;
                }
                // 跨工作区转发不复制选人选组
                if (['group', 'user'].includes(field.type) && old_space_id != space_id) {
                    return;
                }
                var key = field.code;
                var old_v = old_values[key];
                if (old_v) {
                    // 校验 单选，多选，下拉框 字段值是否在新表单对应字段的可选值范围内
                    if (field.type == 'select' || field.type == 'radio') {
                        var options = field.options.split('\n');
                        if (!options.includes(old_v))
                            return;
                    }

                    if (field.type == 'multiSelect') {
                        var options = field.options.split('\n');
                        var old_multiSelected = old_v.split(',');
                        var new_multiSelected = _.intersection(options, old_multiSelected);
                        old_v = new_multiSelected.join(',');
                    }

                    new_values[key] = old_v;
                }
            }

        })
        appr_obj.values = new_values;

        trace_obj.approves = [appr_obj];
        ins_obj.traces = [trace_obj];

        new_ins_id = db.instances.insert(ins_obj);

        // 复制附件
        var collection = cfs.instances;
        var files = collection.find({
            'metadata.instance': instance_id,
            'metadata.current': true
        });
        files.forEach(function(f) {
            var newFile = new FS.File();
            newFile.attachData(f.createReadStream('instances'), {
                type: f.original.type
            }, function(err) {
                if (err) {
                    throw new Meteor.Error(err.error, err.reason);
                }
                newFile.name(f.name());
                newFile.size(f.size());
                var metadata = {
                    owner: user_id,
                    owner_name: user_info.name,
                    space: space_id,
                    instance: new_ins_id,
                    approve: appr_obj._id,
                    current: true
                };
                newFile.metadata = metadata;
                var fileObj = collection.insert(newFile);
                fileObj.update({
                    $set: {
                        'metadata.parent': fileObj._id
                    }
                })
            })

        })

        return new_ins_id;
    }



})