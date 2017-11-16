Meteor.methods
	setUserPassword: (user_id, password) ->
		if !this.userId
			throw new Meteor.Error(400, "请先登录")
		Steedos.validatePassword(password)

		Accounts.setPassword(user_id, password, {logout: true})

