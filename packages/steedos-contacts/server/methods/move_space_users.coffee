Meteor.methods
	move_space_users: (from_org_id, to_org_id, space_user_id)->
		check(from_org_id, String)
		check(to_org_id, String)
		check(space_user_id, String)
		if from_org_id == to_org_id
			return true

		space_user = db.space_users.findOne(space_user_id)
		if space_user
			space = db.spaces.findOne({_id: space_user.space}, {fields: {admins: 1}})
			if not space.admins.includes(this.userId)
				return true

			org_ids = space_user.organizations
			i = 0
			while i < org_ids.length
				if org_ids[i] is from_org_id
					org_ids[i] = to_org_id

				i++

			db.space_users.update({_id: space_user_id}, {$set: {organizations: org_ids}})

			return true

