Meteor.startup ->
    Tracker.autorun (c)->
        if Meteor.userId()
            Meteor.subscribe "rocketchat_subscription"