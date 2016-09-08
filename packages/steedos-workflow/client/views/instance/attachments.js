
Template.instance_attachments.helpers({
    
    enabled_add_attachment: function() {
        if (Session.get("box")=="draft" || Session.get("box")=="inbox")
            return "";
        else
            return "display: none;";
        
    }
    
})


Template.instance_attachment.helpers({

    can_delete: function (currentApproveId, historys) {
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return false;
        var isCurrentApprove = false;
        var isDraftOrInbox = false;
        var isFlowEnable = false;
        var isHistoryLenthZero = false;
        var box = Session.get("box");

        var currentApprove = InstanceManager.getCurrentApprove();
        if (currentApprove && (currentApprove.id == currentApproveId))
            isCurrentApprove = true;

        if (box == "draft" || box == "inbox")
            isDraftOrInbox = true;

        var flow = db.flows.findOne(ins.flow, {fields: {state: 1}});
        if (flow && flow.state == "enabled")
            isFlowEnable = true;

        if (!historys || historys.length == 0) {
            isHistoryLenthZero = true;
        }

        return isCurrentApprove && isDraftOrInbox && isFlowEnable && isHistoryLenthZero;
    },

    getUrl: function (attachVersion) {
        // url = Meteor.absoluteUrl("api/files/instances/") + attachVersion._rev + "/" + attachVersion.filename;
        url = Meteor.absoluteUrl("api/files/instances/") + attachVersion._rev;
        if (!Steedos.isMobile())
            url = url + "?download=true"; 
        return url
    },

    canEdit: function(filename) {
        if (Steedos.isIE() && Session.get('box')=='inbox' && !Steedos.isMobile() && Steedos.isDocFile(filename))
            return true;
        return false;

    },
 
})

Template.instance_attachment.events({
    "click [name='ins_attach_version']": function (event, template) {
        Session.set("attach_id", event.target.id);
        Modal.show('ins_attach_version_modal');
    },
    "click .ins_attach_href": function (event, template) {
        // 在手机上弹出窗口显示附件
        if (Steedos.isMobile()){
            Steedos.openWindow(event.target.getAttribute("href"))
            event.stopPropagation()
            return false;
        }
    },
    "click [name='ins_attach_mobile']": function (event, template) {
        var url = event.target.dataset.downloadurl;
        var filename = template.data.current.filename;
        var rev = template.data.current._rev;
        var length = template.data.current.length;
        Steedos.androidDownload(url, filename, rev, length);
    },
    "click [name='ins_attach_isNode']": function (event, template, attachVersion) {
        // var url = Meteor.absoluteUrl("api/files/instances/") + attachVersion._rev + "/" + attachVersion.filename;
        var furl = event.target.dataset.downloadurl;
        var filename = template.data.current.filename;
        var os = require('os');
        // 判断当前操作系统
        var platform = os.platform();
        if (platform == 'darwin'){
            window.location.href = furl;
        }else{       
            SteedosOffice.editFile(furl,filename);
        }
    },
    "click [name='ins_attach_edit']": function (event, template) {
        Session.set("attach_id", event.target.id);
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
        cfs.instances.remove({_id:file_id}, function(error){InstanceManager.removeAttach();})
        return true;
    }

})


Template.ins_attach_version_modal.helpers({

    attach: function () {
        WorkflowManager.instanceModified.get();

        var ins_id, ins_attach_id;
        ins_id = Session.get("instanceId");
        ins_attach_id = Session.get("attach_id");
        if (!ins_id || !ins_attach_id)
            return;
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return;
        if (!ins.attachments)
            return;
        var attach = ins.attachments.filterProperty("_id", ins_attach_id);
        if (attach) {
            return attach[0];
        } else {
            return;
        }
    },


    attach_version_info: function (attachVersion) {
        var owner_name = attachVersion.created_by_name;
        var uploadedAt = attachVersion.created;
        return owner_name + " , " + $.format.date(uploadedAt, "yyyy-MM-dd HH:mm");
    },

    enabled_add_attachment: function() {
        if (Session.get("box")=="draft" || Session.get("box")=="inbox")
            return "";
        else
            return "display: none;";
        
    },

    current_can_delete: function (currentApproveId, historys) {
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return false;
        var isCurrentApprove = false;
        var isDraftOrInbox = false;
        var isFlowEnable = false;
        var isHistoryLenthZero = false;
        var box = Session.get("box");

        var currentApprove = InstanceManager.getCurrentApprove();
        if (currentApprove.id == currentApproveId)
            isCurrentApprove = true;

        if (box == "draft" || box == "inbox")
            isDraftOrInbox = true;

        var flow = db.flows.findOne(ins.flow, {fields: {state: 1}});
        if (flow && flow.state == "enabled")
            isFlowEnable = true;

        if (!historys || historys.length == 0) {
            isHistoryLenthZero = true;
        }

        return isCurrentApprove && isDraftOrInbox && isFlowEnable && !isHistoryLenthZero;
    },

    getUrl: function (attachVersion) {
        // url = Meteor.absoluteUrl("api/files/instances/") + attachVersion._rev + "/" + attachVersion.filename;
        url = Meteor.absoluteUrl("api/files/instances/") + attachVersion._rev;
        if (!Steedos.isMobile())
            url = url + "?download=true"; 
        return url; 
    }
})


Template.ins_attach_version_modal.events({

    'change .ins-file-version-input': function (event, template) {

        InstanceManager.uploadAttach(event.target.files, true);

        $(".ins-file-version-input").val('')
    },
    "click .ins_attach_href": function (event, template) {
        // 在手机上弹出窗口显示附件
        if (Steedos.isMobile()){
            Steedos.openWindow(event.target.getAttribute("href"))
            event.stopPropagation()
            return false;
        }
    },
    "click [name='ins_attach_mobile']": function (event, template) {
        var url = event.target.dataset.downloadurl;
        var filename =  event.target.dataset.filename;
        var rev = event.target.dataset.rev;
        var length = event.target.dataset.length;
        Steedos.androidDownload(url, filename, rev, length);
    },
})

Template._file_version_DeleteButton.events({

    'click div': function(event, template) {
        var file_id = template.data.file_id;
        if (!file_id) {
           return false;
        }

        Session.set("file_id", file_id);
        cfs.instances.remove({_id:file_id}, function(error){InstanceManager.removeAttach();})
        return true;
    }

})

Template.ins_attach_edit_modal.helpers({

    attach: function () {
        WorkflowManager.instanceModified.get();

        var ins_id, ins_attach_id;
        ins_id = Session.get("instanceId");
        ins_attach_id = Session.get("attach_id");
        if (!ins_id || !ins_attach_id)
            return;
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return;
        if (!ins.attachments)
            return;
        var attach = ins.attachments.filterProperty("_id", ins_attach_id);
        if (attach) {
            return attach[0];
        } else {
            return;
        }
    }

})

Template.ins_attach_edit_modal.onRendered(function(){

    var ins_id, ins_attach_id;
    ins_id = Session.get("instanceId");
    ins_attach_id = Session.get("attach_id");
    if (!ins_id || !ins_attach_id)
        return;
    var ins = WorkflowManager.getInstance();
    if (!ins)
        return;
    if (!ins.attachments)
        return;
    var attach = ins.attachments.filterProperty("_id", ins_attach_id);
    if (attach) {
        att = attach[0];
        TANGER_OCX_OBJ = document.getElementById("TANGER_OCX_OBJ");
        url = Meteor.absoluteUrl("api/files/instances/") + att.current._rev + "/" + att.filename + "?download=true";
        console.log(url);
        TANGER_OCX_OBJ.OpenFromURL(url);

        //设置office用户名
        with (TANGER_OCX_OBJ.ActiveDocument.Application){
            UserName = Meteor.user().name;
        }
        TANGER_OCX_OBJ.ActiveDocument.TrackRevisions = true;
    }

    setTimeout(function(){
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

        var data = TANGER_OCX_OBJ.SaveToURL(Meteor.absoluteUrl('s3/'), "file", "", filename, 0);
                            
        var json_data = eval('('+data+')');

        var fileObj = {};
        fileObj._id = json_data["version_id"];
        fileObj.name = filename;
        fileObj.type = cfs.getContentType(filename);
        fileObj.size = json_data["size"];
        InstanceManager.addAttach(fileObj, true);
    }



})
    






