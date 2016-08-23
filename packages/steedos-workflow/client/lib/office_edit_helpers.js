SteedosOffice = {};
//定义全局变量;
SteedosOffice.fileSHA1; 

function setCos_Signal(str){
    if(window.cos){
        cos.office_signal = str;
    }
}

SteedosOffice.uploadFile = function(filePath, filename){
    var url = require('url');
    var net = require('net');
    var path = require('path');
    var http = require('http');
    console.log("上传中....");
    var fileDataInfo = [
        {urlKey: "name", urlValue: filename}
    ]

    var files = [
        {urlKey: filename, urlValue: filePath}
    ]
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

SteedosOffice.getFileSHA1 = function(filePath,filename,callback){
    var fs = require('fs');
    var crypto = require('crypto');
    var fd = fs.createReadStream(filePath);
    var hash = crypto.createHash('sha1');
    hash.setEncoding('hex');
    fd.pipe(hash);
    fd.on('end', function() {
        hash.end();
        var SHA1 = hash.read();
        console.log('hash.read() ' + SHA1); // the desired sha1sum
        callback(SHA1);
    });
};

SteedosOffice.downloadFile = function(file_url,download_dir,filename){
    var fs = require('fs');
    var crypto = require('crypto');
    var exec = require('child_process').exec;
    var http = require('http');
    var os = require('os');
    var cmd;
    var filePath = download_dir + filename;
    var file = fs.createWriteStream(filePath);
    http.get(encodeURI(file_url), function(res) {
    res.on('data', function(data) {
            file.write(data);
        }).on('end', function(){ 
            file.end();
            // var oldFileHash = "";
            SteedosOffice.getFileSHA1(filePath, filename, function(sha1){
                // debugger;
                // console.log(sha1);
                SteedosOffice.fileSHA1 = sha1;
            });
            // 判断当前操作系统
            var platform = os.platform();
            if (platform == 'darwin'){
                cmd = 'open -W ' + download_dir + '\"' + filename +'\"';
            }else{
                cmd = 'start /wait ' + download_dir + '\"' + filename +'\"';
            }
            Modal.show("attachments_upload_modal");
            debugger;
            setCos_Signal("editing");
            exec(cmd, function(error,stdout,stderr){
                // console.log(error,stdout,stderr);

                Modal.hide("attachments_upload_modal");
                setCos_Signal("finished");
                if (error) {
                    throw error;
                }
                // debugger;
                SteedosOffice.getFileSHA1(filePath,filename,function(sha1){
                    if(SteedosOffice.fileSHA1 != sha1){
                        SteedosOffice.uploadFile(filePath, filename);
                    }else{
                        setCos_Signal("finished");
                    }
                    
                });
            })
        })
    })
};

SteedosOffice.editFile = function(file_url,filename){
    // debugger;
    var fs = require('fs');
    var box = Session.get("box");
    var download_dir = process.env.HOME + '/Documents/' + trl('Workflow') + '/';
    // 判断文件类型
    var suffix =/\.[^\.]+$/.exec(filename);
    var suffixArr = [".doc",".docx",".xls",".xlsx",".ppt",".pptx"];
    var t = 0;
    if (box == "inbox" || box == "draft"){
        for(i=0;i<suffixArr.length;i++){
            if (suffixArr[i] == suffix){
                // 判断附件保存路径是否存在
                fs.exists(download_dir,function(exists){
                    console.log(exists);
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
        if (t == 6){
            window.location.href = file_url;    
        }
    }else{
        window.location.href = file_url;
    }
}
