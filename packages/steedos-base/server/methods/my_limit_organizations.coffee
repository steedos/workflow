Meteor.methods
	get_limit_organizations: (space, my_orgs)->
		check space, String
		check my_orgs, [String]
		isLimit = false
		organizations = []
		setting = db.space_settings.findOne({space: space, key: "contacts_view_limits"})
		limits = setting?.values || [];

		if limits.length
			myLitmitOrgs = []
			for limit in limits
				froms = limit.froms
				tos = limit.tos
				fromsChildren = db.organizations.find({space: space, parents: {$in: froms}}, {fields:{_id: 1}})?.map (n) ->
					return n._id
				for myOrg in my_orgs
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
			if myLitmitOrgs.length > my_orgs.length
				# 如果受限的组织个数小于传入的组织个数，则说明当前用户至少有一个组织是不受限的
				isLimit = false
				organizations = []
			else
				organizations = _.uniq _.flatten.organizations
		return {
			isLimit: isLimit
			organizations:organizations
		}
