FormData = Npm.require('form-data');
fs = Npm.require('fs');
request = Npm.require('request')

InstancesToArchive = (spaces, archive_server, to_archive_api, contract_flows) ->
	@spaces = spaces
	@archive_server = archive_server
	@to_archive_api = to_archive_api
	@contract_flows = contract_flows
	return

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

InstancesToArchive._postFormData = (url, formData) ->
	console.log url
#	formData.submit params, (error, response)->
#		if error
#			console.log "error is"
#			console.log error
#		if response
#			console.log "response is"
#			console.error response.statusCode

	request.post {
		url: url
		formData: formData
	}, (err, httpResponse, body) ->
		if err
			return console.error('upload failed:', err)
		console.log 'Upload successful!  Server responded with:', body
		return

InstancesToArchive::sendContractInstances = (field_map)->

	instances = @getContractInstances()

	that = @

	collection = cfs.instances;

	instances.fetch().forEach (instance, i)->
		if i != 0
			return;
		url = that.archive_server + that.to_archive_api + '?externalId=' + instance._id

#		表单数据
		formData = {}
		user_info = db.users.findOne({_id: instance.applicant})

#		附件
		attachFiles = collection.find({
			'metadata.instance': instance._id,
			'metadata.current': true
		}).fetch();

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

			console.info "key is #{key}, fieldName is #{fieldName}, fieldValue is #{fieldValue}"

			formData[fieldName] = encodeURI(fieldValue)


#		正文附件
		mainFile = attachFiles.filterProperty("main", true)
		mainFile.forEach (f) ->
			formData.attach.push request(Meteor.absoluteUrl("api/files/instances/") + f._id + "/" + encodeURI(f.name()))

#		非正文附件
		nonMainFile =  _.filter attachFiles, (af)-> return af.main != true
		nonMainFile.forEach (f)->
			formData.attach.push request(Meteor.absoluteUrl("api/files/instances/") + f._id + "/" + encodeURI(f.name()))

#		原文
		form = db.forms.findOne({_id: instance.form})
		attachInfoName = "F_#{form?.name}_#{instance._id}_1.htm";
		formData.attach.push request(Meteor.absoluteUrl("workflow/space/#{instance.space}/view/readonly/#{instance._id}/#{encodeURI(attachInfoName)}"))

		console.log Meteor.absoluteUrl("workflow/space/#{instance.space}/view/readonly/#{instance._id}/#{encodeURI(attachInfoName)}")
		console.log formData
		InstancesToArchive._postFormData(url, formData);

