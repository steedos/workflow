Meteor.methods({
    // ??? 能否传阅给当前步骤处理人 如果当前步骤是会签。
    cc_do: function(approve, cc_user_ids, description) {

        var setObj = {};
        var ins_id = approve.instance;
        var trace_id = approve.trace;
        var approve_id = approve._id;
        var instance = db.instances.findOne(ins_id, {
            fields: {
                space: 1,
                traces: 1,
                cc_users: 1,
                values: 1
            }
        });
        var ins_cc_users = instance.cc_users ? instance.cc_users : [];
        var traces = instance.traces;
        var current_user_id = this.userId;
        var space_id = instance.space;

        var from_user_name = db.users.findOne(current_user_id, {
            fields: {
                name: 1
            }
        }).name

        traces.forEach(function(t) {
            if (t._id == trace_id) {
                t.approves.forEach(function(a) {
                    if (a._id == approve_id) {
                        a.cc_users = cc_user_ids;
                    }
                });
                cc_user_ids.forEach(function(userId) {
                    var user = db.users.findOne(userId, {
                        fields: {
                            name: 1
                        }
                    });
                    var space_user = db.space_users.findOne({
                        space: space_id,
                        user: userId
                    }, {
                        fields: {
                            organization: 1
                        }
                    });
                    var org_id = space_user.organization;
                    var organization = db.organizations.findOne(org_id, {
                        fields: {
                            name: 1,
                            fullname: 1
                        }
                    });
                    var appr = {
                        '_id': new Mongo.ObjectID()._str,
                        'instance': ins_id,
                        'trace': trace_id,
                        'is_finished': false,
                        'user': userId,
                        'user_name': user.name,
                        'handler': userId,
                        'handler_name': user.name,
                        'handler_organization': org_id,
                        'handler_organization_name': organization.name,
                        'handler_organization_fullname': organization.fullname,
                        'type': 'cc',
                        'start_date': new Date(),
                        // 'read_date': ,
                        'is_read': false,
                        // 'is_error' : false,
                        // 'values' :  ???
                        'from_user': current_user_id,
                        'from_user_name': from_user_name,
                        'opinion_fields_code': approve.opinion_fields_code,
                        'sign_field_code': (approve.opinion_fields_code && approve.opinion_fields_code.length == 1) ? approve.opinion_fields_code[0] : "",
                        'from_approve_id': approve_id,
                        'cc_description': description
                    };
                    uuflowManager.setRemindInfo(instance.values, appr)
                    t.approves.push(appr);
                })
            }
        })

        setObj.cc_users = ins_cc_users.concat(cc_user_ids);


        setObj.modified = new Date();
        setObj.modified_by = this.userId;
        setObj.traces = traces;

        db.instances.update({
            _id: ins_id
        }, {
            $set: setObj
        });

        instance = db.instances.findOne(ins_id);
        current_user_info = db.users.findOne(current_user_id);
        pushManager.send_instance_notification("trace_approve_cc", instance, "", current_user_info, cc_user_ids);

        flow_id = instance.flow;
        approve.cc_user_ids = cc_user_ids; // 记录下本次传阅的人员ID作为hook接口中的参数
        // 如果已经配置webhook并已激活则触发
        pushManager.triggerWebhook(flow_id, instance, approve)
        return true;
    },

    cc_read: function(approve) {
        var setObj = {};
        var ins_id = approve.instance;
        var instance = db.instances.findOne(ins_id, {
            fields: {
                traces: 1
            }
        });
        var traces = instance.traces;
        var current_user_id = this.userId;

        traces.forEach(function(t) {
            if (t.approves) {
                t.approves.forEach(function(a) {
                    if (a.type == 'cc' && a.user == current_user_id && !a.is_read) {
                        a.is_read = true;
                        a.read_date = new Date();
                    }
                });
            }
        })

        // setObj.modified = new Date();
        // setObj.modified_by = this.userId;
        setObj.traces = traces;

        db.instances.update({
            _id: ins_id
        }, {
            $set: setObj
        });
        return true;
    },

    cc_submit: function(ins_id, description) {
        var setObj = {};

        var instance = db.instances.findOne(ins_id, {
            fields: {
                traces: 1,
                cc_users: 1,
                outbox_users: 1
            }
        });
        var traces = instance.traces;
        var ins_cc_users = instance.cc_users;
        var outbox_users = instance.outbox_users ? instance.outbox_users : [];
        var new_cc_users = [];
        var current_user_id = this.userId;
        var current_approve;

        traces.forEach(function(t) {
            if (t.approves) {
                t.approves.forEach(function(a) {
                    if (a.type == 'cc' && a.user == current_user_id && a.is_finished == false) {
                        a.is_finished = true;
						a.is_read = true;
                        a.finish_date = new Date();
                        a.description = description;
                        a.judge = "submitted";
                        a.cost_time = a.finish_date - a.start_date;
                        current_approve = a;
                    }
                });
            }
        })

        ins_cc_users.forEach(function(u) {
            if (current_user_id != u) {
                new_cc_users.push(u);
            }
        });

        setObj.cc_users = new_cc_users;

        setObj.modified = new Date();
        setObj.modified_by = this.userId;
        setObj.traces = traces;

        outbox_users.push(current_user_id);
        setObj.outbox_users = _.uniq(outbox_users);

        db.instances.update({
            _id: ins_id
        }, {
            $set: setObj
        });

        pushManager.send_message_to_specifyUser("current_user", current_user_id);

        instance = db.instances.findOne(ins_id);
        flow_id = instance.flow;
        // 如果已经配置webhook并已激活则触发
        pushManager.triggerWebhook(flow_id, instance, current_approve)

        return true;
    },

    cc_remove: function(instanceId, approveId) {
        var setObj = {};

        var instance = db.instances.findOne(instanceId, {
            fields: {
                traces: 1,
                cc_users: 1
            }
        });
        var traces = instance.traces;
        var new_approves = [];
        var ins_cc_users = instance.cc_users;
        var new_cc_users = [];
        var trace_id, remove_user_id, multi = false;

        traces.forEach(function(t) {
            if (t.approves) {
                t.approves.forEach(function(a) {
                    if (a._id == approveId) {
                        trace_id = a.trace;
                        remove_user_id = a.user;
                    }
                });
            }
        })

        traces.forEach(function(t) {
            if (t._id == trace_id) {
                if (t.approves) {
                    t.approves.forEach(function(a) {
                        if (!(a._id == approveId && a.type == 'cc' && a.is_finished == false)) {
                            new_approves.push(a);
                        }
                    });
                    t.approves = new_approves;
                }
            }

        })

        new_approves.forEach(function(a) {
            if (a.user == remove_user_id && a.type == 'cc' && a.is_finished == false) {
                multi = true;
            }
        })


        if (!multi) {
            ins_cc_users.forEach(function(u) {
                if (remove_user_id != u) {
                    new_cc_users.push(u);
                }
            });

            setObj.cc_users = new_cc_users;
        }

        setObj.modified = new Date();
        setObj.modified_by = this.userId;
        setObj.traces = traces;

        db.instances.update({
            _id: instanceId
        }, {
            $set: setObj
        });

        pushManager.send_message_to_specifyUser("current_user", remove_user_id);
        return true;
    },

    cc_save: function(ins_id, description) {
        var setObj = {};

        var instance = db.instances.findOne(ins_id, {
            fields: {
                traces: 1
            }
        });
        var traces = instance.traces;
        var new_approves = [];
        var ins_cc_users = instance.cc_users;
        var new_cc_users = [];
        var current_user_id = this.userId;

        traces.forEach(function(t) {
            if (t.approves) {
                t.approves.forEach(function(a) {
                    if (a.user == current_user_id && a.type == 'cc' && a.is_finished == false) {
                        a.description = description;
                        a.judge = "submitted";
                    }
                });
            }
        })

        setObj.traces = traces;

        db.instances.update({
            _id: ins_id
        }, {
            $set: setObj
        });

        return true;
    }
})