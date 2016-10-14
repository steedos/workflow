Setup.validate = (cb)->

	userId = Accounts._storedUserId()
	loginToken = Accounts._storedLoginToken()
	requestData = {}
	if userId and loginToken
		requestData = 
			"X-User-Id": userId
			"X-Auth-Token": loginToken
	$.ajax
		type: "POST",
		url: Meteor.absoluteUrl("api/setup/validate"),
		contentType: "application/json",
		dataType: 'json',
		data: JSON.stringify(requestData),
		xhrFields: 
			withCredentials: true
		crossDomain: true
	.done ( data ) ->
		if data.webservices
			Steedos.settings.webservices = data.webservices
		if cb
			cb();
			

Setup.logout = () ->

		$.ajax
			type: "POST",
			url: Meteor.absoluteUrl("api/setup/logout"),
			dataType: 'json',
			xhrFields: 
			   withCredentials: true
			crossDomain: true,
		.done ( data ) ->
			console.log(data)

Meteor.startup ->
	Setup.validate ()->
		if FlowRouter.current()?.context?.pathname == "/steedos/sign-in"
			if FlowRouter.current()?.queryParams?.redirect
				FlowRouter.go FlowRouter.current().queryParams.redirect
			else
				FlowRouter.go "/"

	Accounts.onLogin ()->
		Setup.validate();