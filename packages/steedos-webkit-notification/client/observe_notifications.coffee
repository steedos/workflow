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
            if !notification?.title && !notification?.text
                return

            options = 
                iconUrl: ''
                title: notification.title
                body: notification.text
                timeout: 15 * 1000

            if notification.payload

                options.payload = notification.payload

                if options.payload.requireInteraction
                    options.requireInteraction = options.payload.requireInteraction

                options.onclick = (event) ->

                    if event.target.payload.app == "calendar"
                        event_url = "/calendar/inbox"
                        if Steedos.isNode() 
                            win = nw.Window.get();
                            if win
                                win.restore();
                                win.focus();
                            Steedos.openWindow(event_url,"_self");    
                        else
                            Steedos.openWindow(event_url,"_self"); 
                    else if event.target.payload.app == "sogo"
                        uid = event.target.payload["imap-uid"]
                        sogo_url = "/sogo?uid="
                        if uid
                            sogo_url += uid
                        if Steedos.isNode() 
                            win = nw.Window.get();
                            if win
                                win.restore();
                                win.focus();
                            FlowRouter.go(sogo_url); 
                        else
                            FlowRouter.go(sogo_url); 
                    else
                        # box = event.target.payload.box || "inbox"
                        # inbox、outbox、draft、pending、completed、monitor

                        instanceId = event.target.payload.instance

                        Meteor.call "calculateBox", instanceId , 
                            (error, result) ->
                                if error
                                    console.log error
                                else
                                    box = result

                                    instance_url = "/workflow/space/" + event.target.payload.space + "/" + box + "/" + event.target.payload.instance
                                
                                    if Steedos.isNode()
                                        win = nw.Window.get();
                                        if win
                                            win.restore();
                                            win.focus();
                                        
                                        # 正在编辑时点击推送提示
                                        if InstanceManager.isAttachLocked Session.get("instanceId"), Meteor.userId()
                                            swal({
                                                title: t("steedos_desktop_edit_office_info"),
                                                confirmButtonText: t("node_office_confirm")
                                            })
                                        else
                                            FlowRouter.go(instance_url);  
                                    else
                                        FlowRouter.go(instance_url); 
                                        # window.open(instance_url);

                    # if window.cos && typeof(window.cos) == 'object'
                    #     if window.cos.win_focus && typeof(window.cos.win_focus) == 'function'
                    #         window.cos.win_focus();
                    #     FlowRouter.go(instance_url);
                    # else
                    #     window.open(instance_url);

            appName = "steedos"

            if notification.from == 'workflow'
                appName = notification.from
            if notification?.payload?.app == 'calendar'
                appName = 'calendar'

            options.iconUrl = Meteor.absoluteUrl() + "images/apps/" + appName + "/AppIcon48x48.png"
            
            if Push.debug
                console.log(options)

            # 客户端非主窗口不弹推送消息
            if (Steedos.isNode() && window.opener.opener)
                return;
            
            notification = $.notification(options)

            # add sound
            msg = new Audio("/sound/notification.mp3")
            msg.play();

            # 任务栏高亮显示
            if Steedos.isNode()
                nw.Window.get().requestAttention(3);

            return;
        )
    else

        if Push.debug
            console.log("add addListener")

        Push.onNotification = (data) ->
            box = 'inbox'# inbox、outbox、draft、pending、completed
            if data && data.payload
                if data.payload.space and data.payload.instance
                    instance_url = '/workflow/space/' + data.payload.space + '/' + box + '/' + data.payload.instance
                    # 执行下面的代码会有BUG:会把下一步骤处理人的手机APP强行跳转到待审核相应单子。见：手机app申请人提交申请单，下一步处理人恰好审批王处于打开状态时，下一步处理人的ios app会刷新 #1018
                    # window.open instance_url
            return

        #后台运行时，点击推送消息
        Push.addListener 'startup', (data) ->
            if Push.debug
                console.log 'Push.Startup: Got message while app was closed/in background:', data
            Push.onNotification data

        #关闭进程时，点击推送消息
        Push.addListener 'message', (data) ->
            if Push.debug
                console.log 'Push.Message: Got message while app is open:', data
            Push.onNotification data
            return