Meteor.methods
    username_init: (spaceId) ->
        #db.spaces.find({is_paid: true, balance: {$gt: 0}});
        space = db.spaces.find({_id: spaceId, admins: this.userId});
        if !space
            return false;
        