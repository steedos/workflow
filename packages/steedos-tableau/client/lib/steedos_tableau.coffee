SteedosTableau = {}

Meteor.startup ()->
	Tracker.autorun (c)->
		user = db.users.findOne({_id: Meteor.userId()})
		if user
			if !user.secrets
				Meteor.call("create_secret","tableau")

			tableau_accounts_token = user.secrets.findPropertyByPK("name","tableau")

			if !tableau_accounts_token
				Meteor.call("create_secret","tableau")



_get_tableau_accounts_token = ()->
	user = db.users.findOne({_id: Meteor.userId()})

	if user
		tableau_accounts_token = user.secrets.findPropertyByPK("name","tableau")
		return tableau_accounts_token?.token

SteedosTableau.get_workflow_instance_by_flow_connector = (spaceId, flowId)->

	accounts_token = _get_tableau_accounts_token()

	if accounts_token
		p = "?accounts_token=" + accounts_token

	url = "api/workflow/tableau/space/#{spaceId}/flow/#{flowId}" + p

	if Meteor.isCordova
		return Meteor.absoluteUrl(url);
	else
		return window.location.origin + "/" + url

SteedosTableau.get_workflow_cost_time_connector = (spaceId)->
	accounts_token = _get_tableau_accounts_token()

	if accounts_token
		p = "?accounts_token=" + accounts_token

	url = "tableau/workflow/space/#{Session.get("spaceId")}/cost_time" + p

	if Meteor.isCordova

		return Meteor.absoluteUrl(url);

	else
		return window.location.origin + "/" + url
