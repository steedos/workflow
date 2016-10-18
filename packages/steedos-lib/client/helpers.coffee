Template.registerHelpers = (dict) ->
    _.each dict, (v, k)->
        Template.registerHelper k, v


TemplateHelpers = 

    equals: (a, b)->
        return a == b
        
    session: (v)->
        return Session.get(v)
        
    absoluteUrl: ->
        return Meteor.absoluteUrl()

    urlPrefix: ->
        return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX

    isMobile: ->
        return $(window).width()<767

    userId: ->
        return Meteor.userId()

    setSpaceId: (spaceId)->
        if !spaceId
            Session.set("spaceId", null)    
            localStorage.removeItem("spaceId:" + Meteor.userId())
        else if spaceId != Session.get("spaceId")
            Session.set("spaceId", spaceId)     
            localStorage.setItem("spaceId:" + Meteor.userId(), spaceId);

    getSpaceId: ()->

        spaceId = Session.get("spaceId")
        if spaceId
            return spaceId

        spaceId = localStorage.getItem("spaceId:" + Meteor.userId())
        if spaceId
            return spaceId
        else
            return undefined;
            
    isSpaceAdmin: (spaceId)->
        if !spaceId
            spaceId = Steedos.getSpaceId()
        if spaceId
            s = db.spaces.findOne(spaceId)
            if s
                return s.admins.includes(Meteor.userId())

    isSpaceOwner: (spaceId)->
        if !spaceId
            spaceId = Steedos.getSpaceId()
        if spaceId
            s = db.spaces.findOne(spaceId)
            if s
                return s.owner == Meteor.userId()

    spaceId: ()->
        return Steedos.getSpaceId();

    spaceName: (spaceId)->
        if !spaceId
            spaceId = Steedos.getSpaceId()
        if spaceId
            space = db.spaces.findOne(spaceId)
            if space
                return space.name

    isPaidSpace: (spaceId)->
        if !spaceId
            spaceId = Steedos.getSpaceId()
        if spaceId
            space = db.spaces.findOne(spaceId)
            if space
                return space.is_paid


    isCloudAdmin: ->
        return Meteor.user()?.is_cloudadmin

    setAppId: (appId)->
        if appId != Session.get("appId")
            Session.set("appId", appId)
            localStorage.setItem("appId:" + Meteor.userId(), if appId then appId else "");

    getAppId: ()->

        appId = Session.get("appId")
        if appId
            return appId

        appId = localStorage.getItem("appId:" + Meteor.userId())
        if appId
            return appId
        else
            return undefined;

    getSpaceApps: ()->
        selector = {}
        if Steedos.getSpaceId()
            space = db.spaces.findOne(Steedos.getSpaceId())
            if space?.apps_enabled?.length>0
                selector._id = {$in: space.apps_enabled}
        if Steedos.isMobile()
            selector.mobile = true
        return db.apps.find(selector, {sort: {sort: 1, space_sort: 1}});

    getSpaceFirstApp: ()->
        selector = {}
        if Steedos.getSpaceId()
            space = db.spaces.findOne(Steedos.getSpaceId())
            if space?.apps_enabled?.length>0
                selector._id = {$in: space.apps_enabled}
        if Steedos.isMobile()
            selector.mobile = true
        return db.apps.findOne(selector, {sort: {sort: 1, space_sort: 1}})

    getLocale: ()->
        if Meteor.user()?.locale
            locale = Meteor.user().locale
        else
            l = window.navigator.userLanguage || window.navigator.language || 'en'
            if l.indexOf("zh") >=0
                locale = "zh-cn"
            else
                locale = "en-us"

    getBadge: (appId, spaceId)->
        if !appId
            return;
        badge = 0
        if appId == "chat"
            subscriptions = db.rocketchat_subscription.find().fetch()
            _.each subscriptions, (s)->
                badge = badge + s.unread
        else 
            if spaceId
                b = db.steedos_keyvalues.findOne({user: Meteor.userId(), space: spaceId, key: "badge"})
                if b
                    badge = b.value?[appId]
            else
                b = db.steedos_keyvalues.findOne({user: Meteor.userId(), space: null, key: "badge"})
                if b
                    badge = b.value?[appId]
        if badge 
            return badge


    locale: ->
        return Steedos.getLocale()

    country: ->
        locale = Steedos.getLocale()
        if locale == "zh-cn"
            return "cn"
        else
            return "us"

    fromNow: (posted)->
        return moment(posted).fromNow()



    isPaid: (app)->
        if !app
            app = "workflow"
        if Session.get('spaceId')
            space = db.spaces.findOne(Session.get('spaceId'))
            if space?.apps_paid?.length >0
                return _.indexOf(space.apps_paid, app)>=0 

    isAndroidApp: ()->
        if Meteor.isCordova
            if device?.platform == "Android"
                return true

        return false

    loginWithCookie: (onSuccess) ->
        userId = Steedos.getCookie("X-User-Id")
        authToken = Steedos.getCookie("X-Auth-Token")
        if userId and authToken
            if Meteor.userId() != userId
                Accounts.connection.setUserId(userId);
                Accounts.loginWithToken authToken,  (err) ->
                    if (err) 
                        Meteor._debug("Error logging in with token: " + err);
                        Accounts.makeClientLoggedOut();
                    else if onSuccess
                        onSuccess();
            else
                onSuccess()

    getCookie: (name)->
        pattern = RegExp(name + "=.[^;]*")
        matched = document.cookie.match(pattern)
        if(matched)
            cookie = matched[0].split('=')
            return cookie[1]
        return false

    isNotSync: (spaceId)->
        if !spaceId
            spaceId = Steedos.getSpaceId()
        if spaceId
            space = db.spaces.findOne({_id:spaceId,imo_cid:{$exists:false},"services.bqq.company_id":{$exists:false},"services.dingtalk.corp_id":{$exists:false}})
            if space
                return space.admins.includes(Meteor.userId())

    isNode: ()->
        return process?.__nwjs

    detectIE: ()->
        ua = window.navigator.userAgent
        msie = ua.indexOf('MSIE ')
        if msie > 0
            # IE 10 or older => return version number
            return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10)
        trident = ua.indexOf('Trident/')
        if trident > 0
            # IE 11 => return version number
            rv = ua.indexOf('rv:')
            return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10)
        edge = ua.indexOf('Edge/')
        if edge > 0
            # Edge (IE 12+) => return version number
            return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10)
        # other browser
        false

    isIE: ()->
        d = Steedos.detectIE()
        if d && d < 12
            return true
        false

    isDocFile: (filename) ->
        #无文件类型时
        if filename.split('.').length < 2
            return false
        # 获取文件类型
        _exp = filename.split('.').pop().toLowerCase()
        switch _exp
            when 'doc'
                return true
            when 'docx'
                return true
            else
                return false
        false

    isMac: ()->
        os = navigator.platform
        macs = ['Mac68K', 'MacPPC', 'Macintosh', 'MacIntel']
        if (macs.includes(os))
            return true
        false

    androidDownload: (url, filename, rev, length) ->
        $(document.body).addClass 'loading'
        fileName = rev + '-' + filename
        size = length
        if typeof length == 'string'
            size = length.to_float()
        window.resolveLocalFileSystemURL cordova.file.externalCacheDirectory, ((directoryEntry) ->
            directoryEntry.getFile fileName, {
                create: true
                exclusive: false
            }, ((fileEntry) ->
                fileEntry.file ((file) ->
                    if file.size == size
                        $(document.body).removeClass 'loading'
                        window.open fileEntry.toURL(), '_system', 'EnableViewPortScale=yes'
                    else
                        sPath = fileEntry.toURL()
                        fileTransfer = new FileTransfer
                        fileEntry.remove()
                        fileTransfer.download url, sPath, ((theFile) ->
                            $(document.body).removeClass 'loading'
                            console.log 'download complete: ' + theFile.toURL()
                            window.open theFile.toURL(), '_system', 'EnableViewPortScale=yes'
                        ), (error) ->
                            $(document.body).removeClass 'loading'
                            console.log 'download error source ' + error.source
                            console.log 'download error target ' + error.target
                            console.log 'upload error code: ' + error.code
                ), (error) ->
                    $(document.body).removeClass 'loading'
                    console.log 'upload error code: ' + error.code
            ), (error) ->
                $(document.body).removeClass 'loading'
                console.log 'get directoryEntry error source ' + error.source
                console.log 'get directoryEntry error target ' + error.target
                console.log 'get directoryEntry error code: ' + error.code
        ), (error) ->
            $(document.body).removeClass 'loading'
            console.log 'resolveLocalFileSystemURL error code: ' + error.code




_.extend Steedos, TemplateHelpers

Template.registerHelpers TemplateHelpers

