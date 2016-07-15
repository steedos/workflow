Steedos.pushSpace = new SubsManager();

Tracker.autorun (c)->
    Steedos.pushSpace.reset();
    Steedos.pushSpace.subscribe("raix_push_notifications");

Meteor.startup ->
    if !Steedos.isMobile()
        
        if Push.debug
            console.log("init notification observeChanges")

        query = db.raix_push_notifications.find();

        handle = query.observeChanges(added: (id, notification) ->
            
            options = 
                iconUrl: ''
                title: notification.title
                body: notification.text
                timeout: 6 * 1000
                onclick: ->
                    console.log 'Pewpew'

            appName = "steedos"

            if notification.from == 'workflow'
                appName = notification.from

            options.iconUrl = Meteor.absoluteUrl() + "images/apps/" + appName + "/AppIcon48x48.png"
            
            if Push.debug
                console.log(options)

            notification = $.notification(options)
            
            return;
        )