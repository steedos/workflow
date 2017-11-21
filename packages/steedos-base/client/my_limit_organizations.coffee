Meteor.startup ->
	if Meteor.isClient
		Tracker.autorun (c)->
			spaceId = Steedos.spaceId()
			unless spaceId
				return
			myOrgs = db.organizations.find().map (n) ->
				return n._id
			Meteor.call "get_limit_organizations", spaceId, myOrgs, (error, results)->
				console.log "results:", results
				if results
					Steedos.my_limit_organizations = results
				if error
					toastr.error(TAPi18n.__(error.reason))