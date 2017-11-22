Meteor.startup ->
	if Meteor.isClient
		Tracker.autorun (c)->
			if Steedos.subsBootstrap.ready("my_spaces")
				spaceId = Steedos.spaceId()
				unless spaceId
					return
				console.log spaceId
				Meteor.call "get_limit_organizations", spaceId, (error, results)->
					console.log "results:", results
					if results
						Steedos.my_limit_organizations = results
					if error
						toastr.error(TAPi18n.__(error.reason))