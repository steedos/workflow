request = Npm.require('request')

logger = new Logger 'Records_QHD -> InstancesToContracts'

InstancesToContracts = (spaces, contrats_server, contract_flows) ->
	@spaces = spaces
	contrats_server = contrats_server
	@contract_flows = contract_flows
	return

InstancesToContracts::getContractInstances = ()->
	return db.instances.find({
		space: {$in: @spaces},
		flow: {$in: @contract_flows},
		is_archived: false,
		is_deleted: false,
		state: "completed",
		"values.record_need": "true",
		$or: [{final_decision: "approved"}, {final_decision: {$exists: false}}, {final_decision: ""}]
	});



InstancesToContracts::sendContractInstances = (api, callback)->
	formData = {}

	formData.attach = new Array()

	formData.flow = encodeURI("合同审批流程")

	instance = db.instances.findOne({_id: "NceuyeWzCqfdd3rdD"})

	form = db.forms.findOne({_id: instance.form})
	attachInfoName = "F_#{form?.name}_#{instance._id}_1.html";
	attachInfoUrl = Meteor.absoluteUrl("workflow/space/") + instance.space + "/view/readonly/" + instance._id + "/" + encodeURI(attachInfoName)
	formData.attach.push request(attachInfoUrl)

	httpResponse = steedosRequest.postFormDataAsync "http://192.168.0.237:7001/qgbg/modules/contracts/rpc/import_contracts.jsp", formData, callback

	console.log httpResponse