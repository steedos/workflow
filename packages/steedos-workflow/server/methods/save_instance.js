Meteor.methods({

    draft_save_instance: function(ins) {
        if (!this.userId)
            return;
        var result = true;
        var setObj = {};
        var traces = ins.traces;
        var flow = db.flows.findOne(ins.flow, {
            fields: {
                "current._id": 1,
                "current.form_version": 1
            }
        });
        var instance = db.instances.findOne(ins._id, {
            fields: {
                applicant: 1
            }
        });
        var applicant_id = ins.applicant;
        var space_id = ins.space;

        setObj.modified = new Date();
        setObj.modified_by = this.userId;
        setObj.attachments = ins.attachments;

        if (flow.current._id != ins.flow_version) {
            result = "upgraded"
                // 流程已升级
            setObj.flow_version = flow.current._id;
            setObj.form_version = flow.current.form_version;
        }

        if (instance.applicant != applicant_id) {
            // 申请人已变换
            var user = db.users.findOne(applicant_id, {
                fields: {
                    name: 1
                }
            });
            var applicant = db.space_users.find({
                space: space_id,
                user: applicant_id
            }, {
                fields: {
                    organization: 1
                }
            });
            var org_id = applicant.fetch()[0].organization;
            var organization = db.organizations.findOne(org_id, {
                fields: {
                    name: 1,
                    fullname: 1
                }
            });

            setObj.applicant = applicant_id;
            setObj.applicant_name = user.name;
            setObj.applicant_organization = org_id;
            setObj.applicant_organization_name = organization.name;
            setObj.applicant_organization_fullname = organization.fullname;

            traces.forEach(function(t) {
                t.approves.forEach(function(a) {
                    a.user = applicant_id;
                    a.user_name = user.name;
                    a.judge = "submitted";
                })
            })

        }
        setObj.traces = traces;

        // 计算申请单标题
        var form = db.forms.findOne(ins.form);
        var name_forumla = form.current.name_forumla;
        if (name_forumla) {
            var values = traces[0].approves[0].values || {};
            var iscript = name_forumla.replace("{", "values['").replace("}", "']");
            var rev = eval(iscript);
            setObj.name = rev || "";
        }

        db.instances.update({
            _id: ins._id
        }, {
            $set: setObj
        });
        return result;
    },

    inbox_save_instance: function(approve) {
        if (!this.userId)
            return;

        var setObj = {};
        var ins_id = approve.instance;
        var trace_id = approve.trace;
        var approve_id = approve.id;
        var values = approve.values;
        var next_steps = approve.next_steps;
        var description = approve.description;
        var judge = approve.judge;
        var next_steps = approve.next_steps;

        var instance = db.instances.findOne(ins_id, {
            fields: {
                traces: 1,
                flow_version: 1,
                flow: 1
            }
        });
        var traces = instance.traces;
        var flow_version = instance.flow_version;
        var flow_id = instance.flow;

        var step_id = "";
        traces.forEach(function(t) {
            if (t._id == trace_id) {
                step_id = t.step;
            }
        })

        var flow = db.flows.findOne(flow_id, {
            fields: {
                current: 1,
                historys: 1
            }
        });
        var step = null;
        if (flow.current._id == flow_version) {
            flow.current.steps.forEach(function(s) {
                if (s._id == step_id)
                    step = s;
            })
        } else {
            flow.historys.forEach(function(h) {
                h.steps.forEach(function(s) {
                    if (s._id == step_id)
                        step = s;
                })
            })
        }

        if (!step)
            return false;
        var step_type = step.step_type;

        traces.forEach(function(t) {
            if (t._id == trace_id) {
                t.approves.forEach(function(a) {
                    if (a._id == approve_id) {
                        a.is_read = true;
                        a.read_date = new Date();
                        a.values = values;
                        a.description = description;
                        a.next_steps = next_steps;
                        if (step_type == "submit" || step_type == "start") {
                            a.judge = "submitted";
                        } else {
                            a.judge = judge;
                        }
                    }
                })
            }
        })

        setObj.modified = new Date();
        setObj.modified_by = this.userId;
        setObj.attachments = approve.attachments;
        setObj.traces = traces;

        db.instances.update({
            _id: ins_id
        }, {
            $set: setObj
        });
        return true;
    }

})