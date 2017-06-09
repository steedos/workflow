Dashboard = 
	GetAuthByName: (auth_name,space_id,user_id) ->
		space = if space_id then space_id else Session.get("spaceId")
		user = if user_id then user_id else Meteor.userId()
		return db.apps_auth_users.findOne({space:space,user:user,auth_name:auth_name})

	GetLoginAuths: (space_id,user_id) ->
		# 遍历当前用户在db.apps_auth_users中的数据，返回如下格式JSON对象，ptr/cnpc为域名。
		# ptr
		# 	login_name
		# 	login_password
		# cnpc
		# 	login_name
		# 	login_password
		auths = {}
		space = if space_id then space_id else Session.get("spaceId")
		user = if user_id then user_id else Meteor.userId()
		db.apps_auth_users.find({space:space,user:user}).forEach (n, i) ->
			if n.is_encrypted
				n.login_password = Steedos.decrypt(n.login_password, n.login_name, Dashboard.cryptIvForAuthUsers)
			auths[n.auth_name] = login_name: n.login_name,login_password: n.login_password
		return auths