Meteor.methods
	setUserPassword: (user_id, space_id, password) ->
		if !this.userId
			throw new Meteor.Error(400, "请先登录")

		spaceUser = db.space_users.findOne({user: user_id, space: space_id})

		if spaceUser.invite_state == "pending" or spaceUser.invite_state == "refused"
			throw new Meteor.Error(400, "该用户尚未同意加入该工作区，无法修改密码")

		Steedos.validatePassword(password)

		Accounts.setPassword(user_id, password, {logout: true})

