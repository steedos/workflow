Meteor.startup ->
	AutoForm.hooks
		updateMailAccount:
			onSuccess: (formType, result) ->
				toastr.success t('saved_successfully');
				AccountManager._auth = null;
			onError: (formType, error) ->
				if error.reason
					toastr.error error.reason
				else
					toastr.error error

	# 邮件通知，定时请求接口后弹出通知，后面改为邮件服务器主动推送方案了，如果不能成功再还原下面的代码
	# if Meteor.isClient
	# 	if Steedos.isNode()
	# 		sogoWebURL = Meteor.settings.public?.sogoWebURL
	# 		tokenKey = 'XSRF-TOKEN'
	# 		intervalSeconds = 10 * 60 * 1000 
	# 		Meteor.setInterval ()->
	# 			console.log "========Meteor.setInterval=======sogo=fetch=mails===="
	# 			chrome.cookies.get {name:tokenKey, url:sogoWebURL}, (token)->
	# 				headers = [{
	# 					name:'X-XSRF-TOKEN',
	# 					value:token.value
	# 				}];
	# 				$.ajax({
	# 					url: "#{sogoWebURL}/so/postmaster@czpmail.com/Mail/0/folderINBOX/view",
	# 					type: "POST",
	# 					beforeSend: (XHR)->
	# 						if (headers && headers.length) 
	# 							return headers.forEach (header)-> 
	# 								return XHR.setRequestHeader(header.name, header.value);
	# 					data:{sortingAttributes: {sort: "arrival", asc: 0}, filters: [{searchBy: "subject", searchInput: "xyz"}]},
	# 					success: (data)->
	# 						console.log("success=", data);
	# 						SogoNotification.send data
	# 					error : (XMLHttpRequest, textStatus, errorThrown)-> 
	# 						console.error("sogo fetch inbox list error:", XMLHttpRequest)
	# 				})
	# 		, intervalSeconds
