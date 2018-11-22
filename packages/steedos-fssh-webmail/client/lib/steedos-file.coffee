if Steedos.isNode()
	fs = nw.require("fs");
	path = nw.require('path');
	os = nw.require('os');
	exec = nw.require('child_process').exec;

	dirname = path.join(path.normalize(process.env.USERPROFILE), "Steedos");

	dirtemp = process.env.TEMP;

	https = nw.require('https');
	http = nw.require('http');

	LocalhostData.rmdir(path.join(dirname, 'temp'))

	temp = LocalhostData.mkdirFolder('temp')
	LocalhostData.mkdirFolder('files', temp)
	LocalhostData.mkdirFolder('cache', temp)

	Steedos.fileDirname = path.join(dirname, 'temp', 'files')

	Steedos.fileCacheDirname = path.join(dirname, 'temp', 'cache')

	showProgress = (receivedBytes, totalBytes)->
		percentage = (receivedBytes * 100) / totalBytes;
		$(".sweet-alert #progressReceived").html(parseInt(percentage))
		$(".sweet-alert .progress-bar").width(percentage + '%')


	Steedos.downLoadConfirm = (url, fileName, domainUrl)->
		swal({
				title: fileName,
				type: "info",
				showCancelButton: true,
				cancelButtonText: "另存为",
				confirmButtonText: "打开",
				closeOnConfirm: false
			},(reason) ->
			if (reason == false)
				console.log('点击了另存为');
				chrome.downloads.download {url: url.toString()}
			else
				swal({
					title: "正在下载",
					text: '''
								<div class="progress-group" style="text-align:left">
									<span class="progress-text">进度</span>
									<span class="progress-number"><b id="progressReceived">0</b>%</span>

									<div class="progress sm">
									  <div class="progress-bar progress-bar-aqua" style="width: 0%"></div>
									</div>
								</div>
							''',
					html: true,
					showConfirmButton: false
				});
				Steedos.downLoadFile url, fileName, domainUrl, ()->
#							console.log('close')
					sweetAlert.close();
		)

	Steedos.downLoadFile = (url, name, domainUrl, cb)->
		domain = new URL(domainUrl).hostname;
		console.log('downLoadFile domain', domain);
		fileCachePath = path.join(path.normalize(Steedos.fileCacheDirname), name);
		filePath = path.join(path.normalize(Steedos.fileDirname), name);
		console.log('filePath', filePath);
		if(LocalhostData.exists(name, Steedos.fileDirname))
			console.log('文件已存在，从临时文件读取');
			Steedos.openFile Steedos.fileDirname, name
			if _.isFunction(cb)
				cb()
			return ;
		console.log('文件不存在，开始下载');
		nw.Window.get().cookies.getAll {'domain': domain},(c) ->
			_cookiesValue = ''
			for i in c
					_cookiesValue += i.name + '=' + i.value + ';'

			headers = {
				'Content-Type' : 'charset=gbk'
				'Cookie': _cookiesValue
			}

			file = fs.createWriteStream(fileCachePath)
			totalBytes = 0;
			receivedBytes = 0;
			req = https.request {
				host: url.hostname()
				path: url.pathname() + url.search()
				port: url.port(),
				method: 'GET'
				headers: headers
				rejectUnauthorized: false
			}, (res)->
				totalBytes = parseInt(res.headers['content-length'], 10);
#				console.log('totalBytes', totalBytes);
				res.on("data", (chunk)->
					file.write(chunk);
					receivedBytes += chunk.length;
#					console.log('进度...', receivedBytes, totalBytes);
					try
						showProgress(receivedBytes, totalBytes);
					catch e
						console.log('progress error', e)
				).on("end", () ->
					file.end()
					file.on 'finish', ()->
						console.log("下载完成");
						console.log('开始转移文件', fileCachePath, filePath);
						fs.renameSync fileCachePath, filePath
						console.log("文件已转移到files文件夹")
						Steedos.openFile Steedos.fileDirname, name
						if _.isFunction(cb)
							cb()
				);
				res.on("error", (err)->
					console.log("请求失败");
				);
			req.on 'error', (e) ->
				console.error('req.on error', e);
			req.end();

	Steedos.openFile = (attachPath, name)->
		cmd = 'start "" ' + '\"' + path.join(attachPath, name) + '\"';
		if os.platform() == 'darwin'
			cmd = 'open "" ' + '\"' + path.join(attachPath, name) + '\"';
		exec cmd, (error, stdout, stderr)->
			console.log("文件已关闭：" + dirname);

