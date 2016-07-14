Steedos.pushSpace = new SubsManager();

Tracker.autorun (c)->
    # Steedos.pushSpace.reset();
    Steedos.pushSpace.subscribe("raix_push_notifications");

Meteor.startup ->
    query = db.raix_push_notifications.find();

    handle = query.observeChanges(added: (id, notification) ->
        console.log id + ' , title is ' + notification.title + ' , text is ' + notification.text
        
        options = 
            # iconUrl: '//www.steedos.com/favicon.ico'
            iconUrl: 'https://www.steedos.com/website/img/workflow/AppIcon76x76.png'
            title: notification.title
            body: notification.text
            timeout: 3 * 1000 #3000
            onclick: ->
                console.log 'Pewpew'

        notification = $.notification(options)
        
        return;
    )