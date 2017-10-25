Meteor.methods
	addContactsUser: (doc) ->
		if !doc.name
			throw new Meteor.Error(400,"contact_needs_name")

		if !doc.organizations
			throw new Meteor.Error(400,"contact_needs_organizations")

		if doc.email && doc.mobile
			phoneNumber = "+86" + doc.mobile
			userObj = db.users.find({
				$or:[{"emails.address": doc.email}, {"phone.number": phoneNumber}]
			}).fetch()
		else if doc.email
			userObj = db.users.find({"emails.address": doc.email}).fetch()
		else if doc.mobile
			phoneNumber = "+86" + doc.mobile
			userObj = db.users.find({"phone.number": phoneNumber}).fetch()

		if userObj.length == 1
			userObj = userObj[0]
		else if userObj.length < 1
			userObj = null
		else if userObj.length > 1
			throw new Meteor.Error(400,"邮件和手机号不匹配")

		console.log userObj
		console.log "=========================="

		if userObj 
			userId = userObj._id
			if doc.email && doc.mobile
				inThisSpaceUsers = db.space_users.find({
					space: doc.space, 
					$or:[{email: doc.email}, {mobile: doc.mobile}]
				}).fetch()
			else if doc.email
				inThisSpaceUsers = db.space_users.find({space: doc.space_users, email: doc.email})
			else if doc.mobile
				inThisSpaceUsers = db.space_users.find({space: doc.space_users, mobile: doc.mobile})
			
			# 判断该用户是否已存在该工作区 
			if inThisSpaceUsers.length
				inThisSpaceUsers.forEach (spaceUser, index) ->
					if spaceUser.invite_state == "refused" or spaceUser.invite_state == "pending"
						db.space_users.direct.update({_id: spaceUser._id}, {$set: {invite_state: "pending", user_accepted: false}})
					else
						throw new Meteor.Error(400, "contact_space_user_exist")
				return "已再次邀请该用户"
			else
				doc.invite_state = "pending"
				doc.user_accepted = false

				db.space_users.insert doc
				return "contact_invitation_sends"

		else
			doc.invite_state = "accepted"
			doc.user_accepted = true
			db.space_users.insert doc

			return "contact_invite_success"

	reInviteUser: (id) ->
		if id
			db.space_users.direct.update({_id: id}, {$set: {invite_state: "pending", user_accepted: false}})
			return id
		else
			throw new Meteor.Error(400, "id is required")

