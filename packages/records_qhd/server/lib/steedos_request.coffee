request = Npm.require('request')

steedosRequest = {}

# 以POST 方式提交formData数据值url
steedosRequest.postFormData = (url, formData, cb) ->
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

steedosRequest.postFormDataAsync = Meteor.wrapAsync(steedosRequest.postFormData);