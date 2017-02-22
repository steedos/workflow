Meteor.startup ->
	Tracker.autorun (c)->
		currentUserId = Meteor.userId()
		if currentUserId and Steedos.subsMail.ready()
			unless db.mail_accounts.findOne({owner:currentUserId})
				unless /^\/emailjs\b/.test(FlowRouter.current().path)
					Modal.show "accounts_guide_modal"