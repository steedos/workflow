if Meteor.isServer

        Meteor.methods
                updateUserUtcOffset: (utcOffset) ->
                        if not @userId?
                                return

                        db.users.update({_id: @userId}, {$set: {utcOffset: utcOffset}})  


if Meteor.isClient
        Tracker.autorun (c)->
                user = Meteor.user()
                if user
                        utcOffset = moment().utcOffset() / 60
                        if user.utcOffset isnt utcOffset
                                Meteor.call 'updateUserUtcOffset', utcOffset, (e,r)->
                                        c.stop()