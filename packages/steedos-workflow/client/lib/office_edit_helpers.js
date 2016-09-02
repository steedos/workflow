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
    
    console.log("上传中....");
    var fileDataInfo = [
        {urlKey: "name", urlValue: filename}
    ]

    var files = [
        {urlKey: filename, urlValue: filePath}
    ]
    // 配置附件上传接口
    var options = {
        host: url.parse(Meteor.absoluteUrl()).hostname,
        port: url.parse(Meteor.absoluteUrl()).port,
        method: "POST",
        path: "/s3/"
    }
    var req = http.request(options, function(res) {
        //res.setEncoding("utf8");
        res.on('data', function(chunk) {
            console.log("RES:" + res);
            console.log('STATUS: ' + res.statusCode);
            console.log('HEADERS: ' + JSON.stringify(res.headers));
            console.log('BODY:' + chunk);
            var chunkStr = JSON.parse(chunk.toString());
            var fileObj;
            fileObj = {};
            fileObj._id = chunkStr.version_id;
            fileObj.name = filename;
            fileObj.type = cfs.getContentType(filename);
            fileObj.size = chunkStr.size;
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

    Modal.show("attachments_upload_modal");
    
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
    var filePath = download_dir + filename;
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
                // 附件上传确认提示框
                swal({
                    title: t("instance_office_upload"),   
                    text: t("instance_office_warning"),   
                    type: t("warning"),   
                    showCancelButton: true,   
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: t("instance_office_confirm"),   
                    cancelButtonText: t("instance_office_cancel"),
                    closeOnConfirm: false,   
                    closeOnCancel: true 
                }, function(isConfirm){
                    if (isConfirm) { 
                        if (states.size > limitSize) {
                            swal({
                                title: warnStr,
                                type: "warning",
                                confirmButtonText: t('OK'),
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
    var filePath = download_dir + filename;
    var file = fs.createWriteStream(filePath);
    http.get(encodeURI(file_url), function(res) {
        res.on('data', function(data) {
                file.write(data);
        }).on('end', function(){ 
            file.end();
            // 获取附件hash值
            SteedosOffice.getFileSHA1(filePath, filename, function(sha1){
                SteedosOffice.fileSHA1 = sha1;
            });
            var prgx86 = process.env["ProgramFiles(x86)"];
            var editPath = trl("steedos_desktop") + '\\vbs\\edit.vbs ';
            var vbsPath = "";
            // 64位系统与32位系统vbs路径不一样
            if (prgx86){
                vbsPath = 'C:\\' + '\"' + 'Program Files (x86)' + '\"' + '\\' + editPath;
            }else{
                vbsPath = 'C:\\' + '\"' + 'Program Files' + '\"' + '\\' + editPath;
            }
            
            var cmd = vbsPath + download_dir + '\"' + filename + '\"';
            
            // 调用edit.vbs对word文档进行在线编辑
            SteedosOffice.vbsEditFile(cmd, download_dir, filename);
        })
    })
};

SteedosOffice.editFile = function(file_url, filename){
    var box = Session.get("box");
    var download_dir = process.env.USERPROFILE + '\\Documents\\' + trl('Workflow') + '\\';
    // 判断文件类型
    var suffix =/\.[^\.]+$/.exec(filename);
    var suffixArr = [".doc",".docx"];
    var t = 0;
    if (box == "inbox" || box == "draft"){
        for(i=0;i<suffixArr.length;i++){
            if (suffixArr[i] == suffix){
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
                // break;
            }else{
                ++t;
            }
        }
        if (t == 2){
            window.location.href = file_url;    
        }
    }else{
        window.location.href = file_url;
    }
}
