Meteor.methods
	addContactsUser: (doc) ->
		if !doc.name
			throw new Meteor.Error(400,"contact_needs_name")

		if !doc.email
			throw new Meteor.Error(400,"contact_needs_email")

		if !doc.organizations
			throw new Meteor.Error(400,"contact_needs_organizations")

		userObj = db.users.findOne({"emails.address": doc.email});
		if userObj 
			userId = userObj._id
			isInThisSpace = db.space_users.findOne({
				space: doc.space, 
				$or:[{email: doc.email}, {mobile: doc.mobile}]
			})
			# 判断该用户是否已存在该工作区
			if isInThisSpace
				if isInThisSpace.invite_state == "refused"
					return "isInThisSpace.invite_state"
				else
					throw new Meteor.Error(400, "contact_space_user_exist")
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
			db.space_users.direct.update({_id: id}, {$set:{invite_state: "pending", user_accepted: false}})
			return id
		else
			throw new Meteor.Error(400, "id is required")

