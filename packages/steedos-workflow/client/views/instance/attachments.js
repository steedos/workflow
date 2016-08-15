
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
        url = Meteor.absoluteUrl("api/files/instances/") + attachVersion._rev + "/" + attachVersion.filename;
        if (!Steedos.isMobile() && !Steedos.isNode())
            url = url + "?download=true"; 
        return url
    }
 
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
        WorkflowManager.androidDownload(url, filename, rev, length);
    },
    "click [name='ins_attach_isNode']": function (event, template, attachVersion) {
        // var url = Meteor.absoluteUrl("api/files/instances/") + attachVersion._rev + "/" + attachVersion.filename;
        var url = event.target.dataset.downloadurl;
        var filename = template.data.current.filename;
        // var rev = template.data.current._rev;
        // var length = template.data.current.length;
        var download_attachments = function(url,filename){
            var fs = require('fs');  
            var url = require('url');  
            var http = require('http');  
            var exec = require('child_process').exec;
            debugger;
            var download_dir = 'C:\\Users\\czp\\Desktop\\steedos';
            var mkdir = 'mkdir -p ' + download_dir;
            var file_url = url;
            // Function to download file using HTTP.get  
            var download_file_httpget = function(file_url) {  
                var options = {  
                    host: url.parse(file_url).host,
                    port: 3000,
                    path: url.parse(file_url).pathname
                };
                var file = fs.createWriteStream(download_dir + filename);
                http.get(options, function(res) {  
                res.on('data', function(data) {  
                        file.write(data);  
                    }).on('end', function() {  
                        file.end();  
                        console.log(filename + ' downloaded to ' + download_dir);  
                    });  
                });  
            };
            var child =fs.exists(download_dir,function(exists){
                if (exists) {
                    download_file_httpget(file_url);
                }else{
                    fs.mkdir(download_dir,0777,function(err){
                    if (err)
                        console.log(err);
                    else
                        download_file_httpget(file_url);
                    })
                }

            }) 
            
            // var child = exec(mkdir, function(error, stdout, stderr) {
            //     alert("22222222");
            //     if (error) 
            //         throw error; 
            //     else 
            //         download_file_httpget(file_url);
            // });
            
            
        }
        download_attachments(url,filename);
    }
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
        url = Meteor.absoluteUrl("api/files/instances/") + attachVersion._rev + "/" + attachVersion.filename;
        if (!Steedos.isMobile() && !Steedos.isNode())  
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
        WorkflowManager.androidDownload(url, filename, rev, length);
    },
    "click [name='ins_attach_isNode']": function (event, template) {
        var url = event.target.dataset.downloadurl;
        var filename =  event.target.dataset.filename;
        var rev = event.target.dataset.rev;
        var length = event.target.dataset.length;
        download_attachments(url,filename); 
    }
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






