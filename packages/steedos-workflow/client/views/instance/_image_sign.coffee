ImageSign.helpers =
	spaceUserSign: (userId)->
		space = ""

		if Meteor.isServer
			space = Template.instance().view.template.steedosData.space
		else
			space = Session.get("spaceId")

		spaceUserSign = db.space_user_signs.findOne({space: space, user: userId});
		return spaceUserSign

	imageURL: (userId)->

		spaceUserSign = ImageSign.helpers.spaceUserSign(userId);

		if spaceUserSign?.sign
			return Steedos.absoluteUrl("api/files/avatars/" + spaceUserSign.sign);
