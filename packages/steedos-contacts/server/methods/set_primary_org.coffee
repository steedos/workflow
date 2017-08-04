Meteor.methods
	set_primary_org: (org_id, space_user_id)->
		check(org_id, String)
		check(space_user_id, String)

		userId = @userId
		unless userId
			return true
		space_user = db.space_users.findOne(space_user_id, {fields: {organization: 1}})
		if space_user
# 			space = db.spaces.findOne({_id: space_user.space}, {fields: {admins: 1}})

# 			org_ids = space_user.organizations

# 			unless space.admins.includes(userId)
# 				# only space admin or org admin can edit space_users
# 				isOrgAdmin = Steedos.isOrgAdminByAllOrgIds org_ids,userId
# 				unless isOrgAdmin
# 					throw new Meteor.Error(400, "organizations_error_org_admins_only")

# 				# only space admin or org admin can edit to_org_id's org
# 				isOrgAdmin = false
# 				isOrgAdmin = Steedos.isOrgAdminByOrgIds [to_org_id],userId
# 				unless isOrgAdmin
# 					throw new Meteor.Error(400, "organizations_error_org_admins_only")

# 			if org_ids && org_ids instanceof Array
# 				org_ids.remove(org_ids.indexOf(from_org_id))
# 				org_ids.push(to_org_id)

# #			i = 0
# #			while i < org_ids.length
# #				if org_ids[i] is from_org_id
# #					org_ids[i] = to_org_id
# #
# #				i++
			if space_user.organization != org_id
				db.space_users.update({_id: space_user_id}, {$set: {organization: org_id}})
			return true
		else
            throw new Meteor.Error(400, "steedos_contacts_error_space_user_not_found");


