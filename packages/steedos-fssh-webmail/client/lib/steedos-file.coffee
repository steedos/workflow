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

	Steedos.fileDirname = path.join(dirname, 'temp', 'files')

	domain = new URL(Meteor.settings.public.fsshWebMailURL).hostname;

	console.log('web mail domain', domain);

	Steedos.downLoadFile = (url, name, cb)->
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

			file = fs.createWriteStream(filePath)

			req = https.request {
				host: url.hostname()
				path: url.pathname() + url.search()
				port: url.port(),
				method: 'GET'
				headers: headers
			}, (res)->
				res.on("data", (chunk)->
					file.write(chunk);
				).on("end", () ->
					file.end();
					console.log("保存成功");
					Steedos.openFile Steedos.fileDirname, name
					if _.isFunction(cb)
						cb()
				);
				res.on("error", (err)->
					console.log("请求失败");
				);
			req.on 'error', (e) ->
				console.error(e);
			req.end();

	Steedos.openFile = (attachPath, name)->
		cmd = 'start "" ' + '\"' + path.join(attachPath, name) + '\"';
		if os.platform() == 'darwin'
			cmd = 'open "" ' + '\"' + path.join(attachPath, name) + '\"';
		exec cmd, (error, stdout, stderr)->
			console.log("文件已关闭：" + dirname);

