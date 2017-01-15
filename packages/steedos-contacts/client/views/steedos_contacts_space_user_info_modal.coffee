Template.steedos_contacts_space_user_info_modal.helpers
	spaceUserName: ->
		spaceUser = db.space_users.findOne this.targetId;
		return spaceUser.name;

	spaceUserEmail: ->
		spaceUser = db.space_users.findOne this.targetId;
		return spaceUser.email;

	spaceUserMobile: ->
		mobile = "";
		spaceUser = db.space_users.findOne this.targetId;
		if spaceUser.mobile
			mobile = spaceUser.mobile
		return mobile;

	spaceUserOrganizations: ->
		spaceUser = db.space_users.findOne this.targetId;
		if spaceUser
			return SteedosDataManager.organizationRemote.find({_id: {$in: spaceUser.organizations}},{fields: {fullname: 1}})

		return []

Template.steedos_contacts_space_user_info_modal.events
		