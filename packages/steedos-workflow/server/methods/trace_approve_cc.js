Meteor.methods({
    // ??? 能否传阅给当前步骤处理人 如果当前步骤是会签。
    cc_do: function (approve, cc_user_ids) {
        var r = Meteor.call('inbox_save_instance', approve);
        if (r) {
            var setObj = {};
            var ins_id = approve.instance;
            var trace_id = approve.trace;
            var approve_id = approve.id;
            var instance = db.instances.findOne(ins_id, {fields: {traces: 1, cc_users: 1}});
            var ins_cc_users = instance.cc_users ? instance.cc_users : [];
            var traces = instance.traces;
            var current_user_id = this.userId;

            traces.forEach(function(t){
                if (t._id == trace_id) {
                    t.approves.forEach(function(a){
                        if (a._id == approve_id) {
                            a.cc_users = cc_user_ids;
                        }
                    });
                    cc_user_ids.forEach(function (userId) {
                        var user = db.users.findOne(userId, {fields: {name: 1}});
                        var space_user = db.space_users.find({space: space_id, user: userId}, {fields: {organization: 1}});
                        var org_id = space_user.fetch()[0].organization;
                        var organization = db.organizations.findOne(org_id, {fields: {name: 1, fullname: 1}});
                        var appr = {
                            '_id' : Meteor.uuid(),
                            'instance' : ins_id,
                            'trace' : trace_id,
                            'is_finished' : false,
                            'user' : userId,
                            'user_name' : user.name,
                            'handler' : userId,
                            'handler_name' : user.name,
                            'handler_organization' : org_id,
                            'handler_organization_name' : organization.name,
                            'handler_organization_fullname' : organization.fullname,
                            'type' : 'cc',
                            'start_date' : new Date(),
                            // 'read_date': ,
                            'is_read': false,
                            // 'is_error' : false,
                            // 'values' :  ???
                            'from_user' : current_user_id
                        };
                        t.push(appr);
                    })
                }
            })
            
            setObj.cc_users = ins_cc_users.concat(cc_user_ids);
            // TODO 去除重复

            setObj.modified = new Date();
            setObj.modified_by = this.userId;
            setObj.traces = traces;

            db.instances.update({_id: ins_id}, {$set: setObj}); 
        }

        return true;
    },

    cc_read: function (approve) {
        var setObj = {};
        var ins_id = approve.instance;
        var trace_id = approve.trace;
        var approve_id = approve.id;
        var instance = db.instances.findOne(ins_id, {fields: {traces: 1}});
        var traces = instance.traces;

        traces.forEach(function(t){
            if (t._id == trace_id) {
                t.approves.forEach(function(a){
                    a.is_read = true;
                    a.read_date = new Date();
                });
            }
        })

        // setObj.modified = new Date();
        // setObj.modified_by = this.userId;
        setObj.traces = traces;

        db.instances.update({_id: ins_id}, {$set: setObj}); 
        return true;
    },

    cc_finished: function (approve) {
        var setObj = {};
        var ins_id = approve.instance;
        var trace_id = approve.trace;
        var approve_id = approve.id;
        var instance = db.instances.findOne(ins_id, {fields: {traces: 1, cc_users: 1}});
        var traces = instance.traces;
        var ins_cc_users = instance.cc_users;
        var new_cc_users = [];
        var current_user_id = this.userId;

        traces.forEach(function(t){
            if (t._id == trace_id) {
                t.approves.forEach(function(a){
                    if (a._id == approve_id) {
                        a.is_finished = true;
                        a.finish_date = new Date();
                    }
                });
            }
        })

        ins_cc_users.forEach(function (u) {
            if (current_user_id != u) {
                new_cc_users.push(u);
            }
        });

        setObj.cc_users = new_cc_users;

        setObj.modified = new Date();
        setObj.modified_by = this.userId;
        setObj.traces = traces;

        db.instances.update({_id: ins_id}, {$set: setObj}); 
        return true;
    },

    cc_remove: function (approve, remove_user_id) {
        var setObj = {};
        var ins_id = approve.instance;
        var trace_id = approve.trace;
        var approve_id = approve.id;
        var instance = db.instances.findOne(ins_id, {fields: {traces: 1}});
        var traces = instance.traces;
        var new_approves = [];
        var ins_cc_users = instance.cc_users;
        var new_cc_users = [];

        traces.forEach(function(t){
            if (t._id == trace_id) {
                t.approves.forEach(function(a){
                    if (!(a.user == remove_user_id && a.type == 'cc')) {
                        new_approves.push(a);
                    }
                });
                t.approves = new_approves;
            }
        })

        ins_cc_users.forEach(function (u) {
            if (remove_user_id != u) {
                new_cc_users.push(u);
            }
        });

        setObj.cc_users = new_cc_users;

        setObj.modified = new Date();
        setObj.modified_by = this.userId;
        setObj.traces = traces;

        db.instances.update({_id: ins_id}, {$set: setObj}); 
    }
})

