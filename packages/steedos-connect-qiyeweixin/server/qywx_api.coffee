# 获取登录信息
Qiyeweixin.getLoginInfo = (access_token,auth_code) ->
	try
		qyapi = Meteor.settings.qiyeweixin?.api?.getLoginInfo
		data = {
			auth_code:auth_code
		}
		response = HTTP.post(
			qyapi + "?access_token=" + access_token, 
			{
				data: data,
				headers:"Content-Type": "application/json"
			})
		if response.statusCode != 200
			throw response
		return response.data
	catch err
		console.error err
		throw _.extend(new Error("Failed to complete OAuth handshake with getLoginInfo. " + err), {response: err})

# 获取服务商的token
Qiyeweixin.getProviderToken = (corpid,provider_secret) ->
	try
		qyapi = Meteor.settings.qiyeweixin?.api?.getProviderToken
		data = {
			corpid:corpid,
			provider_secret:provider_secret
		}
		response = HTTP.post(
			qyapi, 
			{
				data: data,
				headers:"Content-Type": "application/json"
			})
		if response.statusCode != 200
			throw response
		return response.data
	catch err
		console.error err
		throw _.extend(new Error("Failed to complete OAuth handshake with getProviderToken. " + err), {response: err})
		
# 获取suite_access_token:OK
Qiyeweixin.getSuiteAccessToken = (suite_id, suite_secret, suite_ticket) ->
	try
		qyapi = Meteor.settings.qiyeweixin?.api?.getSuiteAccessToken
		console.log "------------suite_access_token------------"
		console.log qyapi
		data = {
			suite_id:suite_id,
			suite_secret:suite_secret,
			suite_ticket:suite_ticket
		}
		response = HTTP.post(
			qyapi, 
			{
				data: data,
				headers:"Content-Type": "application/json"
			})
		console.log '------------获取结果---------------'
		console.log response
		if response.statusCode != 200
			throw response
		return response.data
	catch err
		console.error err
		throw _.extend(new Error("Failed to complete OAuth handshake with getSuiteAccessToken. " + err), {response: err})

# 获取预授权码:OK
Qiyeweixin.getPreAuthCode = (suite_id,suite_access_token) ->
	try
		qyapi = Meteor.settings.qiyeweixin?.api?.getPreAuthCode
		data = {
			suite_id:suite_id
		}
		response = HTTP.post(
			qyapi + "?suite_access_token=" + suite_access_token, 
			{
				data: data,
				headers:"Content-Type": "application/json"
			})
		if response.statusCode != 200
			throw response
		return response.data
	catch err
		console.error err
		throw _.extend(new Error("Failed to complete OAuth handshake with getPreAuthCode. " + err), {response: err})

# 获取企业永久授权码
Qiyeweixin.getPermanentCode = (suite_id,auth_code,suite_access_token) ->
	try
		qyapi = Meteor.settings.qiyeweixin?.api?.getPermanentCode
		data = {
			suite_id:suite_id,
			auth_code:auth_code
		}
		response = HTTP.post(
			qyapi + "?suite_access_token=" + suite_access_token, 
			{
				data: data,
				headers:"Content-Type": "application/json"
			})
		if response.statusCode != 200
			throw response
		return response.data
	catch err
		console.error err
		throw _.extend(new Error("Failed to complete OAuth handshake with getPermanentCode. " + err), {response: err})

# 获取CorpToken
Qiyeweixin.getCorpToken = (auth_corpid,permanent_code,suite_access_token) ->
	try
		qyapi = Meteor.settings.qiyeweixin?.api?.getCorpToken
		data = {
			auth_corpid:auth_corpid,
			permanent_code:permanent_code
		}
		response = HTTP.post(
			qyapi + "?suite_access_token=" + suite_access_token, 
			{
				data: data,
				headers:"Content-Type": "application/json"
			})
		if response.statusCode != 200
			throw response
		return response.data
	catch err
		console.error err
		throw _.extend(new Error("Failed to complete OAuth handshake with getCorpToken. " + err), {response: err})


# 获取管理员列表
Qiyeweixin.getAdminList =(auth_corpid,agentid)->
	try
		o = ServiceConfiguration.configurations.findOne({service: "qiyeweixin"},{suite_access_token:1})
		qyapi = Meteor.settings.qiyeweixin?.api?.getAdminList
		data = {
			auth_corpid:auth_corpid,
			agentid:agentid
		}
		response = HTTP.post(
			qyapi + "?suite_access_token=" + o.suite_access_token, 
			{
				data: data,
				headers:"Content-Type": "application/json"
			})
		if response.statusCode != 200
			throw response
		return response.data.admin
	catch err
		console.error err
		throw _.extend(new Error("Failed to complete OAuth handshake with getAdminList. " + err), {response: err})

# 获取用户信息信息
Qiyeweixin.getUserInfo3rd = (code) ->
	try
		o = ServiceConfiguration.configurations.findOne({service: "qiyeweixin"},{suite_access_token:1})	
		qyapi = Meteor.settings.qiyeweixin?.api?.getUserInfo3rd
		getUserInfo3rdUrl = qyapi + "?access_token=" + o.suite_access_token + "&code=" + code
		response = HTTP.get getUserInfo3rdUrl
		if response.error_code
			throw response.msg
		if response.data.errcode>0 
			throw response.data.errmsg
		return response.data
	catch err
		console.error err
		throw _.extend(new Error("Failed to complete OAuth handshake with getUserInfo3rdUrl. " + err), {response: err})


# 获取部门下用户列表
Qiyeweixin.getUserList =(access_token,department_id)->
	try
		qyapi = Meteor.settings.qiyeweixin?.api?.getUserList
		getUserListUrl = qyapi + "?access_token=" + access_token + "&department_id=" + department_id + "&fetch_child=0"
		response = HTTP.get getUserListUrl
		if response.error_code
			console.error err
			throw response.msg
		if response.data.errcode>0 
			throw response.data.errmsg
		return response.data.userlist
	catch err
		console.error err
		throw _.extend(new Error("Failed to complete OAuth handshake with getUserList. " + err), {response: err})

# 获取当前公司所有用户列表
Qiyeweixin.getAllUserList =(access_token)->
	try
		qyapi = Meteor.settings.qiyeweixin?.api?.getAllUserList
		getAllUserListUrl = qyapi + "?access_token=" + access_token + "&department_id=1&fetch_child=1"
		response = HTTP.get getAllUserListUrl
		if response.error_code
			console.error err
			throw response.msg
		if response.data.errcode>0 
			throw response.data.errmsg
		return response.data.userlist
	catch err
		console.error err
		throw _.extend(new Error("Failed to complete OAuth handshake with getAllUserListUrl. " + err), {response: err})

# 获取部门列表（全量）
Qiyeweixin.getDepartmentList =(access_token)->
	try
		qyapi = Meteor.settings.qiyeweixin?.api?.getDepartmentList
		getDepartmentListUrl = qyapi + "?access_token=" + access_token
		response = HTTP.get getDepartmentListUrl
		if response.error_code
			console.error err
			throw response.msg
		if response.data.errcode>0 
			throw response.data.errmsg
		return response.data.department
	catch err
		console.error err
		throw _.extend(new Error("Failed to complete OAuth handshake with getDepartmentList. " + err), {response: err})
