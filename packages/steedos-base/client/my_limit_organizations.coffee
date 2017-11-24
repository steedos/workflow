Meteor.startup ->
	if Meteor.isClient
		# 默认配置为限制在本单位范围
		Steedos.my_limit_organizations = 
			isLimit: true
			organizations: []
		Tracker.autorun (c)->
			if Steedos.subsBootstrap.ready("my_spaces")
				spaceId = Steedos.spaceId()
				unless spaceId
					return
				if Steedos.isSpaceAdmin()
					# 工作区管理员肯定不会有任何限制
					Steedos.my_limit_organizations.isLimit = false
					Session.set("is_my_limits_loaded", true);
					return
				Meteor.call "get_limit_organizations", spaceId, (error, results)->
					Session.set("is_my_limits_loaded", true);
					if results
						Steedos.my_limit_organizations = results
					if error
						toastr.error(t(error.reason))