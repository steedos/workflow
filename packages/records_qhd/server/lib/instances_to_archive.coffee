request = Npm.require('request')

logger = new Logger 'Records_QHD -> InstancesToArchive'

#logger = console
#
#logger.debug = console.log

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

InstancesToArchive.success = (instance)->
	logger.info("success, name is #{instance.name}, id is #{instance._id}")
	db.instances.direct.update({_id: instance._id}, {$set: {is_archived: true}})

InstancesToArchive.failed = (instance, error)->
	logger.error("failed, name is #{instance.name}, id is #{instance._id}. error: #{error}")

_minxiInstanceData = (formData, instance, field_values, field_map) ->

	if !formData || !instance
		return

	format = "YYYY-MM-DD HH:mm:ss"

	formData.attach = new Array()

	formData.fileID = instance._id

#	常量值处理
	if field_values && _.isObject(field_values)
		field_values_key = _.keys(field_values)
		field_values_key.forEach (k)->
			formData[k] = field_values[k]

#	表单字段处理
	fieldsValues = instance.values

	fieldNames = _.keys(field_map)

	fieldNames.forEach (fieldName)->
		key = field_map[fieldName]

		fieldValue = fieldsValues[key]

		if _.isDate(fieldValue)
			fieldValue = moment(fieldValue).format(format)

		if _.isObject(fieldValue)
			fieldValue = fieldValue?.name

		if _.isArray(fieldValue) && fieldValue.length > 0 && _.isObject(fieldValue)
			fieldValue = fieldValue?.getProperty("name")?.join(",")

		if _.isArray(fieldValue)
			fieldValue = fieldValue?.join(",")

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
	nonMainFile = _.filter attachFiles, (af)-> return af.main != true
	nonMainFile.forEach (f)->
		formData.attach.push request(Meteor.absoluteUrl("api/files/instances/") + f._id + "/" + encodeURI(f.name()))

	#	原文
	form = db.forms.findOne({_id: instance.form})
	attachInfoName = "F_#{form?.name}_#{instance._id}_1.html";
	attachInfoUrl = Meteor.absoluteUrl("workflow/space/") + instance.space + "/view/readonly/" + instance._id + "/" + encodeURI(attachInfoName)
	formData.attach.push request(attachInfoUrl)

	return formData;


# 以POST 方式提交formData数据值url
InstancesToArchive._postFormData = (url, formData, cb) ->
	request.post {
		url: url
		formData: formData
	}, (err, httpResponse, body) ->
		cb err, httpResponse, body

		if err
			console.error('upload failed:', err)
			return
		if httpResponse.statusCode == 200
#			logger.info("success, name is #{formData.TITLE_PROPER}, id is #{formData.fileID}")
			return

InstancesToArchive.postFormDataAsync = Meteor.wrapAsync(InstancesToArchive._postFormData);



InstancesToArchive._sendContractInstance = (url, instance, field_values, field_map, callback) ->

#	表单数据
	formData = {}

	_minxiInstanceData(formData, instance, field_values, field_map)

	logger.debug("_sendContractInstance: #{instance._id}")

	#	发送数据
	httpResponse = InstancesToArchive.postFormDataAsync url, formData, callback

	if httpResponse.statusCode == 200
		InstancesToArchive.success instance
	else
		InstancesToArchive.failed instance, err


InstancesToArchive::sendContractInstances = (field_values, field_map) ->
	console.time("sendContractInstances")
	instances = @getContractInstances()

	that = @
	console.log "instances.length is #{instances.count()}"
	instances.fetch().forEach (instance, i)->
		url = that.archive_server + that.to_archive_api + '?externalId=' + instance._id
		InstancesToArchive._sendContractInstance url, instance, field_values, field_map

	console.timeEnd("sendContractInstances")


InstancesToArchive::sendNonContractInstances = (field_values, field_map) ->
	console.time("sendNonContractInstances")
	instances = getNonContractInstances()
	that = @
	console.log "instances.length is #{instances.count()}"
	instances.fetch().forEach (instance, i)->
		url = that.archive_server + that.to_archive_api + '?externalId=' + instance._id
		InstancesToArchive._sendNonContractInstance url, instance, field_values, field_map

	console.timeEnd("sendNonContractInstances")


InstancesToArchive._sendNonContractInstance = (url, instance, field_values, field_map, callback) ->

	format = "YYYY-MM-DD HH:mm:ss"

#	表单数据
	formData = {}

#	设置归档日期
	now = new Date()

	formData.guidangriqi = moment(now).format(format)

	formData.LAST_FILE_DATE = moment(instance.modified).format(format)

	formData.FILE_DATE = moment(instance.submit_date).format(format)

	formData.TITLE_PROPER = encodeURI(instance.name) || encodeURI("无")

	_minxiInstanceData(formData, instance, field_values, field_map)

	logger.debug("_sendContractInstance: #{instance._id}")

	#	发送数据
	httpResponse = InstancesToArchive.postFormDataAsync url, formData, callback

	if httpResponse.statusCode == 200
		InstancesToArchive.success instance
	else
		InstancesToArchive.failed instance, err