Template.instance_attachments.helpers({

    enabled_add_attachment: function() {
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return "display: none;";

        if (InstanceManager.isCC(ins))
            return "display: none;";

        if (Session.get("box") == "draft" || Session.get("box") == "inbox")
            return "";
        else
            return "display: none;";
    },

    attachments: function() {
        var instanceId = Session.get('instanceId');
        if (!instanceId)
            return;

        return cfs.instances.find({
            'metadata.instance': instanceId,
            'metadata.current': true
        }).fetch();
    }

})


Template.instance_attachment.helpers({

    can_delete: function(currentApproveId, parent_id) {
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return false;

        if (InstanceManager.isCC(ins)) {
            return false;
        }

        var isCurrentApprove = false;
        var isDraftOrInbox = false;
        var isFlowEnable = false;
        var isHistoryLenthZero = false;
        var box = Session.get("box");
        var isLocked = false;

        var currentApprove = InstanceManager.getCurrentApprove();
        if (currentApprove && (currentApprove.id == currentApproveId))
            isCurrentApprove = true;

        if (box == "draft" || box == "inbox")
            isDraftOrInbox = true;

        var flow = db.flows.findOne(ins.flow, {
            fields: {
                state: 1
            }
        });
        if (flow && flow.state == "enabled")
            isFlowEnable = true;

        var count = cfs.instances.find({
            'metadata.parent': parent_id
        }).count();
        if (count == 1) isHistoryLenthZero = true;

        var current = cfs.instances.findOne({
            'metadata.parent': parent_id,
            'metadata.current': true
        });

        if (current && current.metadata && current.metadata.locked_by)
            isLocked = true;

        return isCurrentApprove && isDraftOrInbox && isFlowEnable && isHistoryLenthZero && !isLocked;
    },

    getUrl: function(_rev) {
        // url = Meteor.absoluteUrl("api/files/instances/") + attachVersion._rev + "/" + attachVersion.filename;
        url = Meteor.absoluteUrl("api/files/instances/") + _rev;
        if (!Steedos.isMobile())
            url = url + "?download=true";
        return url
    },


    canEdit: function(filename, locked_by) {
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return false;

        if (InstanceManager.isCC(ins))
            return false;

        var locked = false;
        if (locked_by) locked = true;
        if ((Steedos.isIE() || Steedos.isNode()) && Session.get('box') == 'inbox' && !Steedos.isMobile() && !Steedos.isMac() && Steedos.isDocFile(filename) && !locked)
            return true;

        return false;
    },

})

Template.instance_attachment.events({
    "click [name='ins_attach_version']": function(event, template) {
        Session.set("attach_parent_id", event.target.dataset.parent);
        Modal.show('ins_attach_version_modal');
    },
    "click .ins_attach_href": function(event, template) {
        // 在手机上弹出窗口显示附件
        if (Steedos.isMobile()) {
            Steedos.openWindow(event.target.getAttribute("href"))
            event.stopPropagation()
            return false;
        }
    },
    "click [name='ins_attach_mobile']": function(event, template) {
        var url = event.target.dataset.downloadurl;
        var filename = template.data.name();
        var rev = template.data._id;
        var length = template.data.size();
        Steedos.androidDownload(url, filename, rev, length);
    },
    "click [name='ins_attach_isNode']": function(event, template) {
        Session.set('cfs_file_id', event.target.id);
        Session.set('attach_parent_id', event.target.dataset.parent);
        // 编辑时锁定
        InstanceManager.lockAttach(event.target.id);

        var url = event.target.dataset.downloadurl;
        var filename = event.target.dataset.name;
        NodeManager.editFile(url, filename);
    },
    "click [name='ins_attach_edit']": function(event, template) {
        Session.set("attach_id", event.target.id);
        Session.set('cfs_file_id', event.target.id);
        Session.set('attach_parent_id', event.target.dataset.parent);
        Session.set('cfs_filename', event.target.dataset.name);
        Modal.show('ins_attach_edit_modal');
    },
})

Template._file_DeleteButton.events({

    'click div': function(event, template) {
        var file_id = template.data.file_id;
        if (!file_id) {
            return false;
        }
        Session.set("file_id", file_id);
        cfs.instances.remove({
            _id: file_id
        }, function(error) {
            InstanceManager.removeAttach();
        })
        return true;
    }

})


Template.ins_attach_version_modal.helpers({

    attach_versions: function() {
        var parent = Session.get('attach_parent_id');
        if (!parent) return;

        return cfs.instances.find({
            'metadata.parent': parent
        }, {
            sort: {
                uploadedAt: -1
            }
        }).fetch();
    },

    attach_current_version: function() {
        var parent = Session.get('attach_parent_id');
        if (!parent) return;

        return cfs.instances.findOne({
            'metadata.parent': parent,
            'metadata.current': true
        });
    },


    attach_version_info: function(owner_name, uploadedAt) {
        return owner_name + " , " + $.format.date(uploadedAt, "yyyy-MM-dd HH:mm");
    },

    enabled_add_attachment: function() {
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return "display: none;";

        if (InstanceManager.isCC(ins))
            return "display: none;";

        var parent = Session.get('attach_parent_id');
        if (!parent) return "display: none;";

        var current = cfs.instances.findOne({
            'metadata.parent': parent,
            'metadata.current': true
        });

        if (current && current.metadata && current.metadata.locked_by)
            return "display: none;";

        if (Session.get("box") == "draft" || Session.get("box") == "inbox")
            return "";
        else
            return "display: none;";
    },

    current_can_delete: function(currentApproveId, parent_id) {
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return false;

        if (InstanceManager.isCC(ins)) {
            return false;
        }

        var isCurrentApprove = false;
        var isDraftOrInbox = false;
        var isFlowEnable = false;
        var isHistoryLenthZero = false;
        var box = Session.get("box");
        var isLocked = false;

        var currentApprove = InstanceManager.getCurrentApprove();
        if (currentApprove.id == currentApproveId)
            isCurrentApprove = true;

        if (box == "draft" || box == "inbox")
            isDraftOrInbox = true;

        var flow = db.flows.findOne(ins.flow, {
            fields: {
                state: 1
            }
        });
        if (flow && flow.state == "enabled")
            isFlowEnable = true;

        var count = cfs.instances.find({
            'metadata.parent': parent_id
        }).count();
        if (count == 1) isHistoryLenthZero = true;

        var current = cfs.instances.findOne({
            'metadata.parent': parent_id,
            'metadata.current': true
        });

        if (current && current.metadata && current.metadata.locked_by)
            isLocked = true;

        return isCurrentApprove && isDraftOrInbox && isFlowEnable && !isHistoryLenthZero && !isLocked;
    },

    getUrl: function(_rev) {
        // url = Meteor.absoluteUrl("api/files/instances/") + attachVersion._rev + "/" + attachVersion.filename;
        url = Meteor.absoluteUrl("api/files/instances/") + _rev;
        if (!Steedos.isMobile())
            url = url + "?download=true";
        return url;
    },

    locked_info: function(locked_by_name) {
        return TAPi18n.__('workflow_attach_locked_by', locked_by_name);
    },

    can_unlock: function(locked_by) {
        return locked_by == Meteor.userId();
    }
})


Template.ins_attach_version_modal.events({

    'change .ins-file-version-input': function(event, template) {

        InstanceManager.uploadAttach(event.target.files, true);

        $(".ins-file-version-input").val('')
    },
    "click .ins_attach_href": function(event, template) {
        // 在手机上弹出窗口显示附件
        if (Steedos.isMobile()) {
            Steedos.openWindow(event.target.getAttribute("href"))
            event.stopPropagation()
            return false;
        }
    },
    "click [name='ins_attach_mobile']": function(event, template) {
        var url = event.target.dataset.downloadurl;
        var filename = this.name();
        var rev = this._id;
        var length = this.size();
        Steedos.androidDownload(url, filename, rev, length);
    },
    "click .btn-primary": function(event, template) {
        InstanceManager.unlockAttach(event.target.id);
    },
})

Template._file_version_DeleteButton.events({

    'click div': function(event, template) {
        var file_id = template.data.file_id;
        if (!file_id) {
            return false;
        }

        Session.set("file_id", file_id);
        cfs.instances.remove({
            _id: file_id
        }, function(error) {
            var parent = Session.get('attach_parent_id');
            var current = cfs.instances.find({
                'metadata.parent': parent
            }, {
                sort: {
                    uploadedAt: -1
                }
            }).fetch()[0];
            current.update({
                $set: {
                    'metadata.current': true
                }
            });

            InstanceManager.removeAttach();
        })
        return true;
    }

})

Template.ins_attach_edit_modal.helpers({

    name: function() {
        return Session.get('cfs_filename');
    }

})

Template.ins_attach_edit_modal.onRendered(function() {

    var cfs_file_id = Session.get('cfs_file_id');
    if (!cfs_file_id)
        return;

    // 编辑时锁定
    InstanceManager.lockAttach(cfs_file_id);

    var f = cfs.instances.findOne({
        _id: cfs_file_id
    });
    if (f) {
        TANGER_OCX_OBJ = document.getElementById("TANGER_OCX_OBJ");
        url = Meteor.absoluteUrl("api/files/instances/") + f._id + "/" + f.name() + "?download=true";
        console.log(url);
        TANGER_OCX_OBJ.OpenFromURL(url);

        //设置office用户名
        with(TANGER_OCX_OBJ.ActiveDocument.Application) {
            UserName = Meteor.user().name;
        }
        TANGER_OCX_OBJ.ActiveDocument.TrackRevisions = true;
    }

    setTimeout(function() {
        // set body height
        var total = document.documentElement.clientHeight;
        var header = document.getElementById("attach_edit_modal_header").offsetHeight;
        document.getElementById("attach_edit_modal_body").style.height = (total - header).toString() + "px";
    }, 1);

})

Template.ins_attach_edit_modal.events({
    // save attach
    'click .btn-primary': function(event, template) {
        console.log('edit modal save attach');
        var filename = event.target.dataset.filename;

        var TANGER_OCX_OBJ = document.getElementById("TANGER_OCX_OBJ");

        var params = {};
        params.space = Session.get('spaceId');
        params.instance = Session.get('instanceId');
        params.approve = InstanceManager.getMyApprove().id;
        params.owner = Meteor.userId();
        params.owner_name = Meteor.user().name;
        params.isAddVersion = true;
        params.parent = Session.get('attach_parent_id');
        params.locked_by = Meteor.userId();
        params.locked_by_name = Meteor.user().name;

        var params_str = $.param(params);

        var data = TANGER_OCX_OBJ.SaveToURL(Meteor.absoluteUrl('s3/'), "file", params_str, encodeURIComponent(filename), 0);

        var json_data = eval('(' + data + ')');

        // 编辑时锁定
        Session.set('cfs_file_id', json_data['version_id']);

        var fileObj = {};
        fileObj._id = json_data["version_id"];
        fileObj.name = filename;
        fileObj.type = cfs.getContentType(filename);
        fileObj.size = json_data["size"];
        InstanceManager.addAttach(fileObj, true);
    },

    // 关闭编辑页面
    'click .btn-default': function(event, template) {
        console.log('edit modal close attach');
        InstanceManager.unlockAttach(Session.get('cfs_file_id'));
    }

})