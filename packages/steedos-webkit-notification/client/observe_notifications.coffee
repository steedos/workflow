Steedos.pushSpace = new SubsManager();

Tracker.autorun (c)->
    # Steedos.pushSpace.reset();
    Steedos.pushSpace.subscribe("raix_push_notifications");

Meteor.startup ->
    if !Steedos.isMobile()
        
        if Push.debug
            console.log("init notification observeChanges")

        query = db.raix_push_notifications.find();
        #发起获取发送通知权限请求
        $.notification.requestPermission ->

        handle = query.observeChanges(added: (id, notification) ->
            
            options = 
                iconUrl: ''
                title: notification.title
                body: notification.text
                timeout: 6 * 1000

            if notification.payload

                options.payload = notification.payload

                options.onclick = (event) ->
                    console.log 'notification click...'

                    box = "inbox" # inbox、outbox、draft、pending、completed

                    instance_url = "/workflow/space/" + event.target.payload.space + "/" + box + "/" + event.target.payload.instance
                    
                    if window.cos && typeof(window.cos) == 'object'
                        if window.cos.win_focus && typeof(window.cos.win_focus) == 'function'
                            window.cos.win_focus();
                        FlowRouter.go(instance_url);    
                    else
                        window.open(instance_url);

            appName = "steedos"

            if notification.from == 'workflow'
                appName = notification.from

            options.iconUrl = Meteor.absoluteUrl() + "images/apps/" + appName + "/AppIcon48x48.png"
            
            if Push.debug
                console.log(options)

            notification = $.notification(options)
            
            # add sound
            msg = new Audio("/sound/notification.mp3")
            msg.play();

            return;
        )