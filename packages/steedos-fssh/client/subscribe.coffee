Meteor.startup ->
	Tracker.autorun (c)->
		currentUserId = Meteor.userId()
		if currentUserId and Steedos.subsMail.ready() and Steedos.subsSpace.ready()
			if Meteor.loggingIn()
				# 正在登录中，则不做处理，因为此时Meteor.userId()不足于证明已登录状态
				return
			unless db.space_users.findOne({user:currentUserId})
				swal
					title: "您的账户没有权限访问工作平台！",
					text: "请联系管理员确定您的账户已加入工作平台。",
					type: "warning",
					showCancelButton: false,
					confirmButtonText: "注销"
				, (reason) ->
					$("body").addClass("loading")
					Meteor.logout ->
						$("body").removeClass("loading")
				return
			else
				sweetAlert.close()
			# unless db.mail_accounts.findOne({owner:currentUserId})
			# 	unless /^\/emailjs\b/.test(FlowRouter.current().path)
			# 		Modal.show "accounts_guide_modal"
		else if $(".accounts-guide-modal").length
			Modal.hide "accounts_guide_modal"
