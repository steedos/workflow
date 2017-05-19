@Attachment = {}
logger = new Logger 'Records_ES_Attachment'
request = Npm.require('request')
mkdirp = Npm.require('mkdirp')
fs = Npm.require('fs')
path = Npm.require('path')
execSync = Npm.require('child_process').execSync
Attachment.syncAttachments=(instance_id)->
	downloadType = [
		'application/msword',	#doc
		'application/vnd.openxmlformats-officedocument.wordprocessingml.document',	#docx
		'application/vnd.ms-excel',	#xls
		'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',	#xlsx
		'text/plain'	#txt
		# 'application/pdf'	#pdf
	]
	cfs_instances=cfs.instances.find({'metadata.instance': instance_id, 'original.type': {$in: downloadType }});
	cfs_instances.forEach (cfs_file)->
		if !filePath && __meteor_bootstrap__ && __meteor_bootstrap__.serverDir
			filePath = path.join(__meteor_bootstrap__.serverDir, "../../../records/files/#{cfs_file.metadata.space}/#{cfs_file.metadata.instance}")
		fileName = cfs_file._id+'.txt'
		converterFile = path.join filePath,fileName
		if fs.existsSync converterFile
			readFunc cfs_file,converterFile
		else
			downloadFunc cfs_file,filePath

downloadFunc=(cfs_file,filePath)->
	url = Meteor.absoluteUrl("api/files/instances/") + cfs_file._id + "/" + encodeURI(cfs_file.original.name)
	if !fs.existsSync filePath
		mkdirp.sync filePath
	if !filePath
		logger.error 'FS.Store.FileSystem unable to determine path'
	fileName = cfs_file._id + path.extname(cfs_file.original.name)
	downloadFile = path.join filePath, fileName
	stream = fs.createWriteStream downloadFile,{encoding:'utf8'}
	request.get({
		url: url,
		headers: {
		'referer': Meteor.absoluteUrl()
		}
	}).pipe(stream)

	stream.on 'close', Meteor.bindEnvironment ()->
		converterFunc cfs_file,downloadFile

converterFunc = (cfs_file, downloadFile)->
	extName = path.extname downloadFile
	extName = extName.toUpperCase()
	switch extName
		when '.DOC','.DOCX','.XLS','.XLSX'
			converterOffice cfs_file, downloadFile
		when '.TXT'
			readFile cfs_file,downloadFile

converterOffice=(cfs_file, downloadFile)->
	converterFile = downloadFile.substring(0,downloadFile.lastIndexOf('.'))+'.txt'
	cmd = ''
	cmd += Meteor.settings.records.office_converter_path
	cmd += ' ' + downloadFile
	cmd += ' ' + converterFile
	try
		execSync cmd,{encoding: 'utf8'}
		if cfs_file?.is_delete==true || (!cfs_file?.is_delete)
			fs.unlinkSync downloadFile
		readFunc cfs_file,converterFile
	catch e
		logger.error e

readFunc=(cfs_file,converterFile)->
	readStream = fs.readFileSync converterFile,{encoding:'utf8'}
	content = readStream.toString().substring 1
	index = Meteor.settings.records.es_search_index
	type = "instances"
	instance_id = cfs_file.metadata.instance
	ping_url = es_server + '/' + index + '/' + type + '/' + instance_id
	attachObj = {
		cfs_id:cfs_file._id,
		cfs_owner_name:cfs_file.metadata.owner_name,
		cfs_title:cfs_file.original.name,
		cfs_file:content
	}
	updateAttach(ping_url, attachObj)

updateAttach=(ping_url,attchment)->
	data = {
		"script" : {
			"inline":'ctx._source.attachments.add(params.data)',
			"lang": "painless",
			"params":{
				data:attchment
				}
		}
	}
	try
		result = HTTP.call(
				'POST', ping_url + '/' + '_update',{data:data}
			)
	catch e
		logger.error e+"result is #{result}"