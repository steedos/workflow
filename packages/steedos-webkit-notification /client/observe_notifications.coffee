Steedos.pushSpace = new SubsManager();

Tracker.autorun (c)->
    Steedos.pushSpace.reset();
    Steedos.subsSpace.subscribe("raix_push_notifications");

query = raix_push_notifications.find();

handle = query.observeChanges(added: (id, notification) ->
    console.log notification._id + ' brings the total to ' + notification.title + ' admins.'
    
    options = 
        iconUrl: '//github.com/favicon.ico'
        title: notification.title
        body: notification.text
        timeout: 3000
        onclick: ->
            console.log 'Pewpew'

    notification = $.notification(options)
    
    return;
)