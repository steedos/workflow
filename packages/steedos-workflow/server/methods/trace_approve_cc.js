Array.prototype.uniq = function(){
    var a = [];
    this.forEach(function(b){ 
        if(a.indexOf(b) < 0)
            {a[a.length] = b}
    });
    return a;
};

cc_manager = {}

cc_manager.get_badge = function (user_id) {
    var badge = 0;
    var user_spaces = db.space_users.find({user: user_id, user_accepted: true}).fetch()
    user_spaces.forEach(function (user_space) {
      var c = db.instances.find({space: user_space.space, state: 'pending', $or: [{inbox_users: user_id}, {cc_users: user_id}] }).count()
      badge += c

      sk = db.steedos_keyvalues.findOne({user: user_id, space: user_space.space, key: "badge"})
      if (sk) {
        db.steedos_keyvalues.update({_id: sk._id}, {$set: {"value.workflow": c}})
      }
      else {
        sk_new = {}
        sk_new.user = user_id
        sk_new.space = user_space.space
        sk_new.key = "badge"
        sk_new.value = {"workflow" : c}
        db.steedos_keyvalues.insert(sk_new)
      }
    })
      
        
    sk_all = db.steedos_keyvalues.findOne({user: user_id, space: {$exists: false},  key : "badge"})
    if (sk_all) {
      db.steedos_keyvalues.update({_id: sk_all._id}, {$set: {"value.workflow" : badge}})
    }
    else {
      sk_all_new = {}
      sk_all_new.user = user_id
      sk_all_new.space = undefined
      sk_all_new.key = "badge"
      sk_all_new.value = {"workflow" : badge}
      db.steedos_keyvalues.insert(sk_all_new)
    }

    return badge
}

Meteor.methods({
    // ??? 能否传阅给当前步骤处理人 如果当前步骤是会签。
    cc_do: function (approve, cc_user_ids) {

        var setObj = {};
        var ins_id = approve.instance;
        var trace_id = approve.trace;
        var approve_id = approve.id;
        var instance = db.instances.findOne(ins_id, {fields: {space: 1, traces: 1, cc_users: 1}});
        var ins_cc_users = instance.cc_users ? instance.cc_users : [];
        var traces = instance.traces;
        var current_user_id = this.userId;
        var space_id = instance.space;

        traces.forEach(function(t){
            if (t._id == trace_id) {
                t.approves.forEach(function(a){
                    if (a._id == approve_id) {
                        a.cc_users = cc_user_ids;
                    }
                });
                cc_user_ids.forEach(function (userId) {
                    var user = db.users.findOne(userId, {fields: {name: 1}});
                    var space_user = db.space_users.findOne({space: space_id, user: userId}, {fields: {organization: 1}});
                    var org_id = space_user.organization;
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
                    t.approves.push(appr);
                })
            }
        })
        
        setObj.cc_users = ins_cc_users.concat(cc_user_ids).uniq();
        

        setObj.modified = new Date();
        setObj.modified_by = this.userId;
        setObj.traces = traces;

        db.instances.update({_id: ins_id}, {$set: setObj}); 

        cc_user_ids.forEach(function (userId) {
          cc_manager.get_badge(userId);
        });
            

        return true;
    },

    cc_read: function (approve) {
        var setObj = {};
        var ins_id = approve.instance;
        var trace_id = approve.trace;
        var approve_id = approve.id;
        var instance = db.instances.findOne(ins_id, {fields: {traces: 1}});
        var traces = instance.traces;
        var current_user_id = this.userId;

        traces.forEach(function(t){
            t.approves.forEach(function(a){
                if (a.type == 'cc' && a.user == current_user_id) {
                    a.is_read = true;
                    a.read_date = new Date();
                }
            });
        })

        // setObj.modified = new Date();
        // setObj.modified_by = this.userId;
        setObj.traces = traces;

        db.instances.update({_id: ins_id}, {$set: setObj}); 
        return true;
    },

    cc_submit: function (ins_id, description) {
        var setObj = {};

        var instance = db.instances.findOne(ins_id, {fields: {traces: 1, cc_users: 1, outbox_users: 1}});
        var traces = instance.traces;
        var ins_cc_users = instance.cc_users;
        var outbox_users = instance.outbox_users ? instance.outbox_users : [];
        var new_cc_users = [];
        var current_user_id = this.userId;

        traces.forEach(function(t){
            t.approves.forEach(function(a){
                if (a.type == 'cc' && a.user == current_user_id && a.is_finished == false) {
                    a.is_finished = true;
                    a.finish_date = new Date();
                    a.description = description;
                }
            });
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

        outbox_users.push(current_user_id);
        setObj.outbox_users = outbox_users.uniq();

        db.instances.update({_id: ins_id}, {$set: setObj}); 
        cc_manager.get_badge(current_user_id);
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
        cc_manager.get_badge(remove_user_id);
        return true;
    },

    cc_save: function (ins_id, description) {
        var setObj = {};

        var instance = db.instances.findOne(ins_id, {fields: {traces: 1}});
        var traces = instance.traces;
        var new_approves = [];
        var ins_cc_users = instance.cc_users;
        var new_cc_users = [];
        var current_user_id = this.userId;

        traces.forEach(function(t){
            t.approves.forEach(function(a){
                if (a.user == current_user_id && a.type == 'cc' && a.is_finished == false) {
                    a.description = description;
                }
            });
        })

        setObj.traces = traces;

        db.instances.update({_id: ins_id}, {$set: setObj}); 

        return true;
    }
})

