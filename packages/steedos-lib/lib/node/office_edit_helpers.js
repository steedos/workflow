
Template.registerHelpers = function(dict) {
    _.each(dict, function(v, k) {
        Template.registerHelper(k, v);
    });
};

var TemplateIsNodeHelpers = {

    uploadFile: function(sha1){
        if(oldFileHash != sha1){
            console.log("上传中....");
            var fileDataInfo = [
                {urlKey: "name", urlValue: filename}
            ]

            var files = [
                {urlKey: filename, urlValue: filePath}
            ]
            var options = {
                host: url.parse(Meteor.absoluteUrl()).hostname,//正式上线
                port: url.parse(Meteor.absoluteUrl()).port,
                method: "POST",
                path: "/s3/"
            }
            var req = http.request(options, function(res) {
                //res.setEncoding("utf8");
                res.on('data', function(chunk) {
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

        }else{
            console.log("文件未修改")
        }
    },

    // 获取当前文件的hash值
    getFileSHA1: function(filePath,callback){
        var fd = fs.createReadStream(filePath);
        var hash = crypto.createHash('sha1');  
        hash.setEncoding('hex');
        fd.pipe(hash);
        fd.on('end', function() {
            hash.end();
            var SHA1 = hash.read();
            console.log('hash.read() ' + SHA1); // the desired sha1sum
            uploadFile(SHA1);
        });
    },

    // Function to download file using HTTP.get
    download_file_httpget: function(file_url) {
        var cmd;
        var filePath = download_dir + filename;
        var file = fs.createWriteStream(filePath);
        http.get(encodeURI(file_url), function(res) {
        res.on('data', function(data) {
                file.write(data);
            }).on('end', function(){ 
                file.end();
                var oldFileHash = "";
                getFileSHA1(filePath, function(sha1){
                    oldFileHash = sha1;
                });
                // 判断当前操作系统
                var platform = os.platform();
                if (platform == 'darwin'){
                    cmd = 'open -W ' + download_dir + '\"' + filename +'\"';
                }else{
                    cmd = 'start /wait ' + download_dir + '\"' + filename +'\"';
                }

                // 附件在线编辑
                Modal.show("attachments_upload_modal");
                var child = exec(cmd, function(error,stdout,stderr){
                    // console.log(error,stdout,stderr);
                    Modal.hide("attachments_upload_modal");
                    if (error) {
                        throw error;
                    }
                    getFileSHA1(filePath, callback);
                })
                child.on('exit',function(){
                    console.log('child exit');
                })
            })
        }) 
    },


    office_edit: function(file_url,filename){
        // debugger;
        var download_dir = process.env.HOME + '/Documents/' + trl('Workflow') + '/';
        download_file_httpget(file_url);
        // 判断附件保存路径是否存在
        fs.exists(download_dir,function(exists){
            // console.log(exists);
            if (exists == true){
                // 下载附件到本地
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
};

_.extend(Steedos, TemplateIsNodeHelpers);

Template.registerHelpers(TemplateIsNodeHelpers);