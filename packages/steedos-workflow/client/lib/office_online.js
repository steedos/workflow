OfficeOnline = {}

OfficeOnline.http = {}

OfficeOnline.https = {}

// 定义变量判断是否则正在编辑文档
OfficeOnline.setSignal = "";

var globalWin, url, net, path, http, https, fs;

if (Steedos.isNode()) {
	// turn off SSL validation checking
	if (window.location.protocol == "https:"){
    	process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";
	}

    url = nw.require('url');
    globalWin = nw.Window.get();
    net = nw.require('net');
    path = nw.require('path');
    https = nw.require('https');
    http = nw.require('http');
    fs = nw.require('fs');

    // 关闭客户端时判断是否正在编辑文档，正在编辑时禁止关闭客户端
    globalWin.on("close",function(){
        if(globalWin && (OfficeOnline.setSignal != "editing")){
            globalWin.close(true);
        }
    });
}


// http请求
OfficeOnline.http.downloadFile = function(file_url, download_dir, filename){
    $(document.body).addClass("loading");
    
    $('.loading-text').text(TAPi18n.__("workflow_attachment_downloading") + filename + "...");
    
    var filePath = path.join(download_dir, filename);
    var file = fs.createWriteStream(filePath);
    var dfile = http.get(encodeURI(file_url), function(res) {
        res.on('data', function(data) {
            file.write(data);
        }).on('end', function() {
            file.end();
            $(document.body).removeClass('loading');
            $('.loading-text').text("");
            // 获取附件hash值
            NodeManager.getFileSHA1(filePath, filename, function(sha1) {
                NodeManager.fileSHA1 = sha1;
            });
            // 调用edit.vbs对word文档进行在线编辑
            NodeManager.vbsEditFile(download_dir, filename);
        })
    });
    dfile.on('error', function(e) {
        $(document.body).removeClass('loading');
        $('.loading-text').text("");
        toastr.error(e.message);
    })
}

OfficeOnline.http.uploadFile = function(fileDataInfo, files){
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
        // res.setEncoding("utf8");
        res.on('end', function() {
            $(document.body).removeClass('loading');
            $('.loading-text').text("");

            // 成功上传后删除本地文件
            fs.unlinkSync(filePath);

            // 解锁 
            InstanceManager.unlockAttach(Session.get('cfs_file_id'));

            // 表单添加附件
            InstanceManager.addAttach(fileObj, false);
        });
    })

    req.on('error', function(e) {
        $(document.body).removeClass('loading');
        $('.loading-text').text("");
        console.log('problem with request:' + e.message);
        toastr.error(e.message);
    });
    
    //上传附件
    NodeManager.uploadAttach(fileDataInfo, files, req);
}

// https请求
OfficeOnline.https.downloadFile = function(file_url, download_dir, filename){
    $(document.body).addClass("loading");
    
    $('.loading-text').text(TAPi18n.__("workflow_attachment_downloading") + filename + "...");
    
    var filePath = path.join(download_dir, filename);
    var file = fs.createWriteStream(filePath);
    var dfile = https.get(encodeURI(file_url), function(res) {
        res.on('data', function(data) {
            file.write(data);
        }).on('end', function() {
            file.end();
            $(document.body).removeClass('loading');
            $('.loading-text').text("");
            // 获取附件hash值
            NodeManager.getFileSHA1(filePath, filename, function(sha1) {
                NodeManager.fileSHA1 = sha1;
            });
            // 调用edit.vbs对word文档进行在线编辑
            NodeManager.vbsEditFile(download_dir, filename);
        })
    });
    dfile.on('error', function(e) {
        $(document.body).removeClass('loading');
        $('.loading-text').text("");
        toastr.error(e.message);
    })
}


OfficeOnline.https.uploadFile = function(fileDataInfo, files){
    // 配置附件上传接口
    var options = {
        host: url.parse(Meteor.absoluteUrl()).hostname,
        port: url.parse(Meteor.absoluteUrl()).port,
        method: "POST",
        path: "/s3/"
    }
    var req = https.request(options, function(res) {
        var fileObj = {};
        res.on('data', function(chunk) {
            var chunkStr = JSON.parse(chunk.toString());
            fileObj._id = chunkStr.version_id;
            fileObj.name = filename;
            fileObj.type = cfs.getContentType(filename);
            fileObj.size = chunkStr.size;
        });
        // res.setEncoding("utf8");
        res.on('end', function() {
            $(document.body).removeClass('loading');
            $('.loading-text').text("");

            // 成功上传后删除本地文件
            fs.unlinkSync(filePath);

            // 解锁 
            InstanceManager.unlockAttach(Session.get('cfs_file_id'));

            // 表单添加附件
            InstanceManager.addAttach(fileObj, false);
        });
    })

    req.on('error', function(e) {
        $(document.body).removeClass('loading');
        $('.loading-text').text("");
        console.log('problem with request:' + e.message);
        toastr.error(e.message);
    });

    //上传附件 
    NodeManager.uploadAttach(fileDataInfo, files, req);
}

//上传附件
OfficeOnline.uploadFile = function(fileDataInfo, files){
	return OfficeOnline[window.location.protocol.replace(":","")].uploadFile(fileDataInfo, files);
}

//下载附件
OfficeOnline.downloadFile = function(file_url, download_dir, filename){
	return OfficeOnline[window.location.protocol.replace(":","")].downloadFile(file_url, download_dir, filename);
}