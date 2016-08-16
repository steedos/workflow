
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
        var furl = event.target.dataset.downloadurl;
        var filename = template.data.current.filename;
        console.log(furl);
        console.log(filename);
        // var rev = template.data.current._rev;
        // var length = template.data.current.length;
        var download_attachments = function(file_url,filename){
            var fs = require('fs');  
            var url = require('url');  
            var http = require('http');
            var net = require('net');
            var crypto = require('crypto');
            var exec = require('child_process').exec;
            // debugger;
            var download_dir = 'C:\\Users\\czp\\Desktop\\steedos\\';
            // var file_url = furl;
            console.log("file_url " + file_url);
            // Function to download file using HTTP.get  
            var download_file_httpget = function(file_url) {
                var file = fs.createWriteStream(download_dir + filename);
                http.get(encodeURI(file_url), function(res) {  
                res.on('data', function(data) {  
                        file.write(data);  
                    }).on('end', function(){  
                        file.end();  
                        console.log(filename + ' downloaded to ' + download_dir);
                        // debugger;
                        // 获取当前文件的hash值
                        function getFileSHA1(filePath,callback){
                            var fd = fs.createReadStream(filePath);
                            var hash = crypto.createHash('sha1');  
                            hash.setEncoding('hex');
                            fd.pipe(hash);
                            var c = fd.on('end', function() {
                                hash.end();
                                var SHA1 = hash.read();
                                console.log('hash.read() ' + SHA1); // the desired sha1sum

                                callback(SHA1);
                            });
                            // var s = SHA1;
                            // return s;     
                        }
                        var filePath = download_dir + filename;
                        var oldFileHash = "";
                        getFileSHA1(filePath, function(sha1){
                            oldFileHash = sha1;
                        });
                        // 附件在线编辑
                        var child = exec('start /wait ' + filePath, function(error,stdout,stderr){
                            // console.log(error,stdout,stderr);
                            debugger;
                            // if (fileOrgin != fileEdit){
                            //     alert("File has changed");
                            // }
                            
                            callback = function(sha1){
                                if(oldFileHash != sha1){
                                    console.log("上传中....")
                                }else{
                                    console.log("文件未修改")
                                }
                            }
                            getFileSHA1(filePath, callback);

                        })
                    });
                }); 
            };
            // 判断附件保存路径是否存在
            var child =fs.exists(download_dir,function(exists){
                // console.log(exists);
                if (exists == true){
                    download_file_httpget(file_url);
                }else{
                    fs.mkdir(download_dir,function(err){
                        if (err) {
                            throw err;
                        }else{
                            download_file_httpget(file_url);
                        }
                    })
                }
            })
            
            
        }
        download_attachments(furl,filename);
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






