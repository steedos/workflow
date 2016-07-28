Meteor.startup ->

    Tracker.autorun (c) ->
        user = Meteor.user()
        locale = Steedos.getLocale();

        if locale == "zh-cn"
            TAPi18n.setLanguage("zh-CN")
            moment.locale("zh-cn")
        else 
            TAPi18n.setLanguage("en")
            moment.locale("en")

        