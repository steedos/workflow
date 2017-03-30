if Meteor.isServer
    Meteor.publish 'space_user_signs', (spaceId)->
        
        return db.space_user_signs.find({space: spaceId});
