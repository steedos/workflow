SteedosOffice = {};
//定义全局变量;
SteedosOffice.fileSHA1; 

var url, net, path, http, fs, crypto, exec
if (window.require){
    url = window.require('url');
    net = window.require('net');
    path = window.require('path');
    http = window.require('http');
    fs = window.require('fs');
    crypto = window.require('crypto');
    exec = window.require('child_process').exec;
}

function setCos_Signal(str){
    if(window.cos){
        cos.office_signal = str;
    }
}

SteedosOffice.uploadFile = function(filePath, filename){
    
    $(document.body).addClass("loading");
    $('.loading-text').text(TAPi18n.__("workflow_attachment_uploading") + filename + "...");
    var fileDataInfo = [
        {urlKey: "name", urlValue: filename}
    ]

    var files = [
        {urlKey: "filePath", urlValue: filePath}
    ]
    // 配置附件上传接口
    var options = {
        host: url.parse(Meteor.absoluteUrl()).hostname,
        port: url.parse(Meteor.absoluteUrl()).port,
        method: "POST",
        path: "/s3/"
    }
    var req = http.request(options, function(res) {
        var fileObj = {};
        res.on('data', function(chunk) {
            var chunkStr = JSON.parse(chunk.toString());          
            fileObj._id = chunkStr.version_id;
            fileObj.name = filename;
            fileObj.type = cfs.getContentType(filename);
            fileObj.size = chunkStr.size;
        });
        //res.setEncoding("utf8");
        res.on('end', function() {
            $(document.body).removeClass('loading');
            $('.loading-text').text("");
            // 表单添加附件
            InstanceManager.addAttach(fileObj, false);
        });
    })

    req.on('error', function(e) {
        console.log('problem with request:' + e.message);
        console.log(e);
    });
    InstanceManager.isNodeUploadAttach(fileDataInfo, files, req);
    Modal.hide("attachments_upload_modal");
    console.log("done");
};

SteedosOffice.getFileSHA1 = function(filePath, filename, callback){
    var fd = fs.createReadStream(filePath);
    var hash = crypto.createHash('sha1');
    hash.setEncoding('hex');
    fd.pipe(hash);
    fd.on('end', function(){
        hash.end();
        var SHA1 = hash.read();
        console.log('hash.read() ' + SHA1); // the desired sha1sum
        callback(SHA1);
    });
};

SteedosOffice.vbsEditFile = function(cmd, download_dir, filename){
    var filePath = download_dir + filename;
    
    Modal.show("attachments_upload_modal",{filename: filename});
    
    // 专业版文件大小不能超过100M
    var maximumFileSize = 100 * 1024 * 1024;
    // 免费版大小不能超过1M
    var freeMaximumFileSize = 1024 * 1024;

    var limitSize, warnStr;

    var is_paid = WorkflowManager.isPaidSpace(Session.get('spaceId'));

    if (is_paid) {
      limitSize = maximumFileSize;
      warnStr = t("workflow_attachment_paid_size_limit");
    }
    else {
      limitSize = freeMaximumFileSize;
      warnStr = t("workflow_attachment_free_size_limit");
    }
    // 执行vbs编辑word
    var child = exec(cmd);
    //正在编辑
    setCos_Signal("editing");
    
    child.on('error',function(error){
        console.error(error);
    });
    child.on('close',function(){
        // 完成编辑
        Modal.hide("attachments_upload_modal");
        
        // 修改后附件大小
        var states =  fs.statSync(filePath);
        console.log('states.size: ' + states.size);
        
        setCos_Signal("finished");
        SteedosOffice.getFileSHA1(filePath,filename,function(sha1){
            if(SteedosOffice.fileSHA1 != sha1){
                var setting  = {
                        title: t("instance_office_warning"),
                        text: t("instance_office_filename") + filename, 
                        type: t("warning"),   
                        showCancelButton: true,   
                        confirmButtonColor: "#DD6B55",
                        confirmButtonText: t("instance_office_confirm"),   
                        cancelButtonText: t("instance_office_cancel"),
                        closeOnConfirm: true,  
                        closeOnCancel: true 
                    }
                
                if (states.size > limitSize) {
                    setting.closeOnConfirm = false;
                }   

                swal(setting, function(isConfirm){
                    if (isConfirm) { 
                        if (states.size > limitSize) {
                            swal({
                                title: warnStr,
                                type: "warning",
                                confirmButtonText: t("instance_office_confirm"),
                                closeOnConfirm: true
                            }, function(){
                                SteedosOffice.vbsEditFile(cmd, download_dir, filename);
                            });
                        }else{
                            SteedosOffice.uploadFile(filePath, filename);
                        }
                    }
                })
            }
        })
    })         
}

SteedosOffice.downloadFile = function(file_url, download_dir, filename){
    $(document.body).addClass("loading");
    $('.loading-text').text(TAPi18n.__("workflow_attachment_downloading") + filename + "...");
    var filePath = path.join(download_dir,filename) ;
    var file = fs.createWriteStream(filePath);
    var dfile = http.get(encodeURI(file_url), function(res) {
        res.on('data', function(data) {
                file.write(data);
        }).on('end', function(){ 
            file.end();
            $(document.body).removeClass('loading');
            $('.loading-text').text("");
            // 获取附件hash值
            SteedosOffice.getFileSHA1(filePath, filename, function(sha1){
                SteedosOffice.fileSHA1 = sha1;
            });
            var homePath = process.cwd() ;
            var cmd = '\"' + homePath + '\"' + '\\vbs\\edit.vbs ' + '\"' + download_dir + filename + '\" ' + Meteor.users.findOne().name;
            console.log(cmd);
            // 调用edit.vbs对word文档进行在线编辑
            SteedosOffice.vbsEditFile(cmd, download_dir, filename);
        })
    });
    dfile.on('error',function(e){
        $(document.body).removeClass('loading');
        $('.loading-text').text("");
        // throw new Meteor.Error(400, e.message);
        console.log(e.message);
    })
};

SteedosOffice.editFile = function(file_url, filename){
    var download_dir = "";
    //获取系统Documents路径
    var docPath = process.env.USERPROFILE + "\\Documents\\";
    fs.exists(docPath,function(exists){
        if (exists == true){
            download_dir = docPath + t('Workflow') + "\\";
        }else{
            download_dir = process.env.USERPROFILE + "\\My Documents\\" + t('Workflow') + "\\";
        }
        // 判断附件保存路径是否存在
        fs.exists(download_dir,function(exists){
            if (exists == true){
                // 下载附件到本地
                SteedosOffice.downloadFile(file_url,download_dir,filename);
            }else{
                // 新建路径并下载附件到本地
                fs.mkdir(download_dir,function(err){
                    if (err) {
                        throw err;
                        console.log(err);
                    }else{
                        SteedosOffice.downloadFile(file_url,download_dir,filename);
                    }
                })
            }
        });
    })
}
