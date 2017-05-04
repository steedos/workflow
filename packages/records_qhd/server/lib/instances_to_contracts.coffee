request = Npm.require('request')

logger = new Logger 'Records_QHD -> InstancesToContracts'

_fieldMap = """
	{
		projectName: values["计划编号"],
		contractType: values["合同类型"],
		chengBanDanWei: values["承办单位"],
		chengBanRen: values["承办人员"],
		otherUnit: values["对方单位"],
		registeredCapital: values["对方注册资金"] * 10000,
		contractAmount: values["价款酬金"],
		signedDate: values["签订日期"],
		startDate: values["开始日期"],
		overDate: values["终止日期"],
		remarks: values["备注"],
		boP: values["收支类别"],
		isConnectedTransaction: values["是否关联交易"],
		contractId: values["合同编号"],
		contractName: values["合同名称"]
	}
"""

InstancesToContracts = (spaces, contracts_server, contract_flows) ->
	@spaces = spaces
	@contracts_server = contracts_server
	@contract_flows = contract_flows
	return

InstancesToContracts::getContractInstances = ()->
	return db.instances.find({
		space: {$in: @spaces},
		flow: {$in: @contract_flows},
		is_archived: false,
		is_deleted: false,
		state: "completed",
		$or: [{final_decision: "approved"}, {final_decision: {$exists: false}}, {final_decision: ""}]
	});


_minxiInstanceData = (formData, instance) ->
	if !formData || !instance
		return

	format = "YYYY-MM-DD HH:mm:ss"

	formData.fileID = instance._id

	field_values = InstanceManager.handlerInstanceByFieldMap(instance, _fieldMap);

	formData = _.extend formData, field_values

	fieldNames = _.keys(formData)

	fieldNames.forEach (key)->
		fieldValue = formData[key]

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

		formData[key] = encodeURI(fieldValue)

	formData.attach = new Array()

	#	提交人信息
	user_info = db.users.findOne({_id: instance.applicant})

	#	正文附件
	mainFile = cfs.instances.find({
		'metadata.instance': instance._id,
		'metadata.current': true,
		"metadata.main": true
	}).fetch()

	mainFile.forEach (f) ->
		formData.attach.push request(Meteor.absoluteUrl("api/files/instances/") + f._id + "/" + encodeURI(f.name()))

	#	非正文附件
	nonMainFile = cfs.instances.find({
		'metadata.instance': instance._id,
		'metadata.current': true,
		"metadata.main": {$ne: true}
	})

	nonMainFile.forEach (f)->
		formData.attach.push request(Meteor.absoluteUrl("api/files/instances/") + f._id + "/" + encodeURI(f.name()))


	#	原文
	form = db.forms.findOne({_id: instance.form})
	attachInfoName = "F_#{form?.name}_#{instance._id}_1.html";
	attachInfoUrl = Meteor.absoluteUrl("workflow/space/") + instance.space + "/view/readonly/" + instance._id + "/" + encodeURI(attachInfoName)
	formData.attach.push request(attachInfoUrl)

	return formData;


InstancesToContracts::sendContractInstances = (api, callback)->

	that = @

	formData = {}

	formData.attach = new Array()

#	instances = @getContractInstances()

	instances = instance = db.instances.find({_id: "CzScbQEt37nTN7mLB"}).fetch()

	instances.forEach (instance)->
		url = that.contracts_server + api + '?externalId=' + instance._id

		flow = db.flows.findOne({_id: instance.flow});

		if flow
			formData.flowName = encodeURI(flow.name)

		_minxiInstanceData(formData, instance)

		httpResponse = steedosRequest.postFormDataAsync url, formData, callback

		console.log httpResponse.body