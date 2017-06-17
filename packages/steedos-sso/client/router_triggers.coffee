checkAndLogin = (context)->
	if Accounts._storedUserId()
		if context?.queryParams?["X-User-Id"] && Meteor?.userId() != context?.queryParams?["X-User-Id"]
			console.log "logout : #{Meteor.userId()}"
			SteedosSSO.login(context)
	else
		console.log "Not Logged In"
		SteedosSSO.login(context)


FlowRouter.triggers.enter([checkAndLogin]);
