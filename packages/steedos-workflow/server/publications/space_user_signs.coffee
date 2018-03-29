if Meteor.isServer
    Meteor.publish 'space_user_signs', (spaceId) ->
        check spaceId, String

        unless this.userId
            return this.ready()

        return db.space_user_signs.find({ space: spaceId })
