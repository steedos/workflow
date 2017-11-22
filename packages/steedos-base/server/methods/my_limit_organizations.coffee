Meteor.methods
	get_limit_organizations: (space)->
		# 根据当前用户所属组织，查询出当前用户限定的组织查看范围
		# 返回的isLimit为true表示限定在当前用户所在组织范围，organizations值记录额外的组织范围
		# 返回的isLimit为false表示不限定组织范围，即表示能看整个工作区的组织
		# 默认返回限定在当前用户所属组织
		check space, String
		reValue =
			isLimit: true
			organizations: []
		unless this.userId
			return reValue
		isLimit = false
		organizations = []
		setting = db.space_settings.findOne({space: space, key: "contacts_view_limits"})
		limits = setting?.values || [];

		if limits.length
			myOrgs = db.organizations.find({space: space, users: this.userId}, {fields:{_id: 1}}).map (n) ->
				return n._id
			unless myOrgs.length
				return reValue
			
			myLitmitOrgs = []
			for limit in limits
				froms = limit.froms
				tos = limit.tos
				fromsChildren = db.organizations.find({space: space, parents: {$in: froms}}, {fields:{_id: 1}})?.map (n) ->
					return n._id
				for myOrg in myOrgs
					tempIsLimit = false
					if froms.indexOf(myOrg) > -1
						tempIsLimit = true
					else
						if fromsChildren.indexOf(myOrg) > -1
							tempIsLimit = true
					if tempIsLimit
						isLimit = true
						organizations.push tos
						myLitmitOrgs.push myOrg

			myLitmitOrgs = _.uniq myLitmitOrgs
			if myLitmitOrgs.length > myOrgs.length
				# 如果受限的组织个数小于传入的组织个数，则说明当前用户至少有一个组织是不受限的
				isLimit = false
				organizations = []
			else
				organizations = _.uniq _.flatten organizations
		reValue.isLimit = isLimit
		reValue.organizations = organizations
		return reValue
