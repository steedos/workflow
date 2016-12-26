ALY = Npm.require('aliyun-sdk');

Aliyun_push = {};

Aliyun_push.sendMessage = (userTokens, notification, callback) ->
    ALYPUSH = new (ALY.PUSH)(
        accessKeyId: Meteor.settings.push.aliyun.accessKeyId
        secretAccessKey: Meteor.settings.push.aliyun.secretAccessKey
        endpoint: Meteor.settings.push.aliyun.endpoint
        apiVersion: Meteor.settings.push.aliyun.apiVersion);

    aliyunTokens = new Array

    userTokens.forEach (userToken) ->
        arr = userToken.split(':')
        aliyunTokens.push arr[arr.length - 1]

    data = 
        AppKey: Meteor.settings.push.aliyun.appKey
        Target: 'device'
        TargetValue: aliyunTokens.toString()
        Title: notification.title
        Summary: notification.text

    ALYPUSH.pushNoticeToAndroid data, callback

Meteor.startup ->
    
    config = {
        debug: true
        keepNotifications: true
        sendInterval: 1000
        sendBatchSize: 10
        production: true
    }

    if !_.isEmpty(Meteor.settings.push?.apn)
        config.apn = {
            keyData: Meteor.settings.push.apn.keyData
            certData: Meteor.settings.push.apn.certData
        }
    if !_.isEmpty(Meteor.settings.push?.gcm)
        config.gcm = {
            projectNumber: Meteor.settings.push.gcm.projectNumber
            apiKey: Meteor.settings.push.gcm.apiKey
        }
    console.log "projectNumber: #{config.gcm.projectNumber}"

    Push.Configure config
    
    if Meteor.settings.push?.aliyun and Push and typeof Push.sendGCM == 'function'
        
        Push.old_sendGCM = Push.sendGCM;

        Push.sendAliyun = (userTokens, notification) ->
            if Push.debug
                console.log 'sendAliyun', userTokens, notification

            if Match.test(notification.gcm, Object)
                notification = _.extend({}, notification, notification.gcm)
            # Make sure userTokens are an array of strings
            if userTokens == '' + userTokens
                userTokens = [ userTokens ]
            # Check if any tokens in there to send
            if !userTokens.length
                console.log 'sendGCM no push tokens found'
                return
            if Push.debug
                console.log 'sendAliyun', userTokens, notification

            Fiber = Npm.require('fibers')
      
            userToken = if userTokens.length == 1 then userTokens[0] else null
            Aliyun_push.sendMessage userTokens, notification, (err, result) ->
                if err
                    console.log 'ANDROID ERROR: result of sender: ' + result
                else
                    if result == null
                        console.log 'ANDROID: Result of sender is null'
                    return

                    if Push.debug
                        console.log 'ANDROID: Result of sender: ' + JSON.stringify(result)

                    if result.canonical_ids == 1 and userToken
                        Fiber((self) ->
                            try
                                self.callback self.oldToken, self.newToken
                            catch err
                        ).run
                            oldToken: gcm: userToken
                            newToken: gcm: "aliyun:" + result.results[0].registration_id
                            callback: _replaceToken
                    if result.failure != 0 and userToken
                        Fiber((self) ->
                            try
                                self.callback self.token
                            catch err
                        ).run
                            token: gcm: userToken
                            callback: _removeToken



        Push.sendGCM = (userTokens, notification) ->
            if Push.debug
                console.log 'sendGCM from aliyun-> Push.sendGCM'
            if Match.test(notification.gcm, Object)
                notification = _.extend({}, notification, notification.gcm)
            # Make sure userTokens are an array of strings
            if userTokens == '' + userTokens
                userTokens = [ userTokens ]
            # Check if any tokens in there to send
            if !userTokens.length
                console.log 'sendGCM no push tokens found'
                return
            if Push.debug
                console.log 'sendGCM', userTokens, notification

            aliyunTokens = userTokens.filter((item) ->
                                item.indexOf('aliyun:') > -1
                            )
            if Push.debug
                console.log 'aliyunTokens is ', aliyunTokens.toString()

            gcmTokens = userTokens.filter((item) ->
                                item.indexOf("aliyun:") < 0
                            )
            if Push.debug
                console.log 'gcmTokens is ' , gcmTokens.toString();

            Push.sendAliyun(aliyunTokens, notification);

            Push.old_sendGCM(gcmTokens, notification);



