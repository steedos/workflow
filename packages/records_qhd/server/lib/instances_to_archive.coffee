request = Npm.require('request')

# spaces: Array 工作区ID
# archive_server: String 档案系统服务
# to_archive_api String 档案API
# contract_flows： Array 合同类流程
InstancesToArchive = (spaces, archive_server, to_archive_api, contract_flows) ->
	@spaces = spaces
	@archive_server = archive_server
	@to_archive_api = to_archive_api
	@contract_flows = contract_flows
	return

#	获取合同类的申请单：正常结束的(不包括取消申请、被驳回的申请单)
InstancesToArchive::getContractInstances = ()->
	return db.instances.find({
		space: {$in: @spaces},
		flow: {$in: @contract_flows},
		is_archived: false,
		is_deleted: false,
		state: "completed",
		final_decision: "approved"
	});

InstancesToArchive::getNonContractInstances = ()->
	return db.instances.find({
		space: {$in: @spaces},
		flow: {$nin: @contract_flows},
		is_archived: false,
		is_deleted: false,
		state: "completed",
		final_decision: "approved"
	});

# 以POST 方式提交formData数据值url
InstancesToArchive._postFormData = (url, formData, cb) ->
	request.post {
		url: url
		formData: formData
	}, (err, httpResponse, body) ->

		cb err, httpResponse, body

		if err
			return console.error('upload failed:', err)
		if httpResponse.statusCode == 200
#			console.info "httpResponse.statusCode is #{httpResponse.statusCode}"
			return

InstancesToArchive.success = (instance)->
	RecordsQHDLogger.instancesToArchive.info("[InstancesToArchive] success,id is #{instance._id}")
	db.instances.direct.update({_id: instance._id}, {$set: {is_archived: true}})

InstancesToArchive.failed = (instance, error)->
	RecordsQHDLogger.instancesToArchive.error("[InstancesToArchive] failed,id is #{instance._id}. error: #{error}")

InstancesToArchive._sendContractInstance = (url, instance, field_map) ->
	RecordsQHDLogger.instancesToArchive.debug("_sendContractInstance: #{instance._id}")
#	表单数据
	formData = {}

	formData.attach = new Array()

	fieldsValues = instance.values

	fieldNames = _.keys(field_map)

	fieldNames.forEach (fieldName)->
		key = field_map[fieldName]

		fieldValue = fieldsValues[key]

		switch fieldName
			when 'fileID'
				fieldValue = instance._id
			when 'chengbandanwei'
				fieldValue = fieldValue?.name

		if !fieldValue
			fieldValue = ''

		formData[fieldName] = encodeURI(fieldValue)

#	提交人信息
	user_info = db.users.findOne({_id: instance.applicant})

#	附件
	attachFiles = cfs.instances.find({
		'metadata.instance': instance._id,
		'metadata.current': true
	}).fetch();

#	正文附件
	mainFile = attachFiles.filterProperty("main", true)
	mainFile.forEach (f) ->
		formData.attach.push request(Meteor.absoluteUrl("api/files/instances/") + f._id + "/" + encodeURI(f.name()))

#	非正文附件
	nonMainFile =  _.filter attachFiles, (af)-> return af.main != true
	nonMainFile.forEach (f)->
		formData.attach.push request(Meteor.absoluteUrl("api/files/instances/") + f._id + "/" + encodeURI(f.name()))

#	原文
	form = db.forms.findOne({_id: instance.form})
	attachInfoName = "F_#{form?.name}_#{instance._id}_1.html";
	attachInfoUrl = Meteor.absoluteUrl("workflow/space/") + instance.space + "/view/readonly/" + instance._id + "/" + encodeURI(attachInfoName)
	formData.attach.push request(attachInfoUrl)

#	发送数据
	InstancesToArchive._postFormData url, formData, Meteor.bindEnvironment((err, httpResponse, body)->
			if httpResponse.statusCode == 200
				InstancesToArchive.success instance
			else
				InstancesToArchive.failed instance, err
		)



InstancesToArchive::sendContractInstances = (field_map)->
	instances = @getContractInstances()

	that = @

	instances.fetch().forEach (instance, i)->
		if i > 300
			return
		url = that.archive_server + that.to_archive_api + '?externalId=' + instance._id
		InstancesToArchive._sendContractInstance url, instance, field_map

