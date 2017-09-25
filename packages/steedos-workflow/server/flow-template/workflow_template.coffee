workflowTemplate = {}

#可用此脚本从模板工作区做批量导出：
#使用管理员账户登录后，进入FlowModules，在控制台执行以下脚本即可
#db.forms.find({state:"enabled"}).forEach(function(form){window.open(Meteor.absoluteUrl("api/workflow/export/form?form="+form._id))})
workflowTemplate["en"] =[]

#可用此脚本从模板工作区做批量导出：
#使用管理员账户登录后，进入模板专区，在控制台执行以下脚本即可
#db.forms.find({state:"enabled"}).forEach(function(form){window.open(Meteor.absoluteUrl("api/workflow/export/form?form="+form._id))})
workflowTemplate["zh-CN"] =[]

Meteor.startup ()->
	fs = Npm.require('fs')
	path = Npm.require('path')
	mime = Npm.require('mime')
	readFileList = (pathDir, filesList)->
		files = fs.readdirSync(pathDir)
		files.forEach (name, index)->
			stat = fs.statSync(pathDir + "\\" + name)
			if stat.isDirectory()
				# 递归读取文件
				readFileList(pathDir + "\\" + name, filesList)
			else
				obj = {}
				obj.path = pathDir
				obj.name = name
				filesList.push(obj)

	#获取zh-cn文件夹下的所有文件
	filesList_cn = []
	path_cn = path.join(__meteor_bootstrap__.serverDir, '../../../../../../workflow-templates/zh-cn/default')
	if fs.existsSync(path_cn)
		readFileList(path_cn, filesList_cn)
		filesList_cn.forEach (file)->
			if mime.getType(file.name) is "application/json"
				data = fs.readFileSync(file.path + "\\" + file.name, 'utf8')
				workflowTemplate["zh-CN"].push(JSON.parse(data))

	#获取en-us文件夹下的所有文件
	filesList_us = []
	path_us = path.join(__meteor_bootstrap__.serverDir, '../../../../../../workflow-templates/en-us/default')
	if fs.existsSync(path_us)
		readFileList(path_us, filesList_us)
		filesList_us.forEach (file)->
			if mime.getType(file.name) is "application/json"
				data = fs.readFileSync(file.path + "\\" + file.name, 'utf8')
				workflowTemplate["en"].push(JSON.parse(data))


