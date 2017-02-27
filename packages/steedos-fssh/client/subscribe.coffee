Meteor.startup ->
	Tracker.autorun (c)->
		currentUserId = Meteor.userId()
		if currentUserId and Steedos.subsMail.ready()
			if Meteor.loggingIn()
				# 正在登录中，则不做处理，因为此时Meteor.userId()不足于证明已登录状态
				return
			unless db.mail_accounts.findOne({owner:currentUserId})
				unless /^\/emailjs\b/.test(FlowRouter.current().path)
					Modal.show "accounts_guide_modal"
		else if $(".accounts-guide-modal").length
			Modal.hide "accounts_guide_modal"
