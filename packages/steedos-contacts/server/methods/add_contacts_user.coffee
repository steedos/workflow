Meteor.methods
	addContactsUser: (doc) ->
		if !doc.name
			throw new Meteor.Error(400,"contact_needs_name")

		if !doc.organizations
			throw new Meteor.Error(400,"contact_needs_organizations")

		# if doc.email && doc.mobile
		# 	phoneNumber = "+86" + doc.mobile
		# 	userObj = db.users.find({
		# 		$or:[{"emails.address": doc.email}, {"phone.number": phoneNumber}]
		# 	}).fetch()
		# else if doc.email
		# 	userObj = db.users.find({"emails.address": doc.email}).fetch()
		# else if doc.mobile
		# 	phoneNumber = "+86" + doc.mobile
		# 	userObj = db.users.find({"phone.number": phoneNumber}).fetch()

		# if userObj.length == 1
		# 	userObj = userObj[0]
		# else if userObj.length < 1
		# 	userObj = null
		# else if userObj.length > 1
		# 	throw new Meteor.Error(400,"contact_mail_not_match_phine")

		# if userObj 
		# 	# 用户是否在当前工作区已经存在的逻辑在space_users.before.insert
		# 	doc.invite_state = "pending"
		# 	doc.user_accepted = false

		# 	db.space_users.insert doc
		# 	return "contact_invitation_sends"

		# else
		# 	doc.invite_state = "accepted"
		# 	doc.user_accepted = true
		db.space_users.insert doc

		return "contact_invite_success"

	reInviteUser: (id) ->
		if id
			db.space_users.direct.update({_id: id}, {$set: {invite_state: "pending", user_accepted: false}})
			return id
		else
			throw new Meteor.Error(400, "id is required")

