Meteor.methods
	addContactsUser: (doc) ->
		if !doc.name
			throw new Meteor.Error(400,"contact_needs_name")

		if !doc.organizations
			throw new Meteor.Error(400,"contact_needs_organizations")

		db.space_users.insert doc

		return "contact_invite_success"

	reInviteUser: (id) ->
		if id
			db.space_users.direct.update({_id: id}, {$set: {invite_state: "pending", user_accepted: false}})
			return id
		else
			throw new Meteor.Error(400, "id is required")

