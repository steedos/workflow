fs = require('fs')

logger = new Logger 'Records_QHD -> AttachmentsToArchive'

object_name = 'archive_records'

# 正文附件上传
collection = cfs.files

AttachmentsToArchive = (instance, archive) ->
	@instance = instance
	@archive = archive
	return

getFileHistoryName = (fileName, historyName, stuff) ->
	regExp = /\.[^\.]+/
	fName = fileName.replace(regExp, "")
	extensionHistory = regExp.exec(historyName)
	if(extensionHistory)
		fName = fName + "_" + stuff + extensionHistory
	else
		fName = fName + "_" + stuff
	return fName

insertCMSFile = (fileObj,fileVersions,i)->
	fileCollection = Creator.getObject("cms_files").db
	# 名字需要重新取，根据档案规则
	strCount = (Array(2).join('0') + i).slice(-2)
	fileName = "集团公司" + strCount

	newCMSFileObjId = fileCollection.direct.insert {
			name: fileName
			description: ''
			extention: fileObj?.original?.name.split('.').pop()
			size: fileObj?.original?.size
			versions: fileVersions
			parent: {
				o:object_name,
				ids:[fileObj?.metadata?.record_id]
			}
			owner: fileObj?.metadata?.owner
			space: fileObj?.metadata?.space
			created_by : fileObj?.metadata?.owner
			modified: fileObj?.modified
			uploadedAt: new Date()
		}
	return newCMSFileObjId

insertFile = (f,space,archive)->
	newFile = new FS.File()
	newFile.name f.name()
	newFile.size f.size()
	newFile.metadata = {
				owner: f?.metadata?.owner
				owner_name : f?.metadata?.owner_name,
				space : space,
				record_id : archive._id,
				object_name : object_name,
				parent : '',
				current : f?.metadata?.current,
				main : f?.metadata?.main
			}

	newFile.attachData f.createReadStream('instances'), {type: f.original.type}, (err) ->
		if err
			throw new Meteor.Error(err.error, err.reason)
		fileObj = collection.insert newFile
		if fileObj
			return fileObj
		else
			return null
			logger.error "文件上传失败：#{f._id},#{f.name()}. error: "

syncFile = (f,i,space,archive)->
	try
		# 保存文件的所有版本ID
		fileVersions = []
		# 新增文件
		fileObj = insertFile f,space,archive

		fileObj.modified = f?.copies?.instances?.updatedAt

		if fileObj?
			fileVersions.push fileObj._id
		# 文件历史版本
		fileHistory = cfs.instances.find({
			'metadata.instance': f?.metadata?.instance,
			'metadata.current': {$ne: true},
			"metadata.main": f?.metadata?.main,
			"metadata.parent": f?.metadata?.parent
		}, {sort: {uploadedAt: -1}}).fetch()
		# 新增文件的每一个历史版本
		fileHistory.forEach (fh) ->
			fileHistoryObj = insertFile fh,space,archive
			if fileHistoryObj?
				fileVersions.push fileHistoryObj._id
		# 新建cms_file表
		newCMSFileObjId = insertCMSFile fileObj,fileVersions,i
		# 文件表与cms_file表关联
		if newCMSFileObjId
			collection.update(
				{_id:{$in:fileVersions}},
				{$set: {'metadata.parent' : newCMSFileObjId}},
				{multi:true})
		else
			logger.error "更新cms_files表失败：#{f._id},#{f.name()}. error: "
	catch e
		logger.error "文件下载失败：#{f._id},#{f.name()}. error: " + e


syncOriginalFile = (instance,archive)->
	form = db.forms.findOne({_id: instance?.form})

	fileName = "集团公司01.html"

	space = db.spaces.findOne({_id: instance.space})

	user = db.users.findOne({_id: space.owner})

	options = {showTrace: false, showAttachments: false, absolute: true}

	html = InstanceReadOnlyTemplate.getInstanceHtml(user, space, instance, options)

	dataBuf = new Buffer(html)

	newFile = new FS.File()

	newFile.name fileName

	console.log fileName

	console.log "-------------------"

	console.log newFile.name

	newFile.metadata = {
				owner: f?.metadata?.owner
				owner_name : f?.metadata?.owner_name,
				space : instance?.space,
				record_id : archive?._id,
				object_name : object_name,
				parent : '',
				current : f?.metadata?.current,
				main : f?.metadata?.main
			}

	newFile.modified = new Date()

	newFile.attachData dataBuf, {type: 'text/html'}, (err) ->
		if err
			throw new Meteor.Error(err.error, err.reason)
		fileObj = collection.insert newFile
		if fileObj
			insertCMSFile fileObj,[fileObj._id],1
		else
			return null
			logger.error "文件上传失败：#{f._id},#{f.name()}. error: "

AttachmentsToArchive::syncAttachments = ()->
	instance = @instance
	archive = @archive

	## 同步原文
	syncOriginalFile instance,archive

	## 同步正文附件
	files = []
	# 正文文件
	mainFile = cfs.instances.find({
		'metadata.instance': @instance._id,
		'metadata.current': true,
		"metadata.main": true
	}).fetch()

	# 需要同步每一个正文
	mainFile.forEach (f) ->
		files.push f

	# 同步附件
	#	非正文附件
	nonMainFile = cfs.instances.find({
		'metadata.instance': @instance._id,
		'metadata.current': true,
		"metadata.main": {$ne: true}
	}).fetch()

	nonMainFile.forEach (f)->
		console.log f.name()
		files.push f

	files.forEach (file,i)->
		i = i + 2
		syncFile file,i,instance.space,archive

	length = files.length

	# 同步分发的文件
	if instance?.distribute_from_instance
		disFiles = []
		# 正文文件
		disMainFile = cfs.instances.find({
			'metadata.instance': instance?.distribute_from_instance,
			'metadata.current': true,
			"metadata.main": true
		}).fetch()
		# 需要同步每一个正文
		disMainFile.forEach (f) ->
			disFiles.push f
		# 同步附件
		#	非正文附件
		disNonMainFile = cfs.instances.find({
			'metadata.instance': instance?.distribute_from_instance,
			'metadata.current': true,
			"metadata.main": {$ne: true}
		}).fetch()
		disNonMainFile.forEach (f)->
			disFiles.push f

		disFiles.forEach (file,i)->
			i = i + length + 1
			syncFile file,i,instance.space,archive
	




