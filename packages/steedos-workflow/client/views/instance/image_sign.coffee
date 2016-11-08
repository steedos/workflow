Template.imageSign.helpers
    imageURL: (userId)->
        spaceUserSign = db.space_user_signs.findOne({space:Session.get("spaceId"),user: userId});

        if spaceUserSign?.sign
            return Meteor.absoluteUrl() + "/api/files/avatars/" + spaceUserSign.sign;