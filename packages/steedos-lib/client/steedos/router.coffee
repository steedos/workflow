
FlowRouter.notFound = 
    action: ()->
        if !Meteor.userId()
            BlazeLayout.render 'loginLayout',
                main: "not-found"
        else
            BlazeLayout.render 'masterLayout',
                main: "not-found"

FlowRouter.triggers.enter [()->
    Session.set("router-path", FlowRouter.current().path)
]

FlowRouter.route '/', 
    action: (params, queryParams)->
        if (!Meteor.userId())
            FlowRouter.go "/steedos/sign-in";
        else 
            firstApp = Steedos.getSpaceFirstApp()
            if !firstApp
                # 这里等待db.apps加载完成后，找到并进入第一个spaceApps的路由，在apps加载完成前显示loading界面
                BlazeLayout.render 'steedosLoading'
                $("body").addClass('loading')
            else
                FlowRouter.go("/app/" + firstApp._id);


# FlowRouter.route '/steedos', 
#   action: (params, queryParams)->
#       if !Meteor.userId()
#           FlowRouter.go "/steedos/sign-in";
#           return true
#       else
#           FlowRouter.go "/steedos/springboard";


FlowRouter.route '/steedos/logout', 
    action: (params, queryParams)->
        #AccountsTemplates.logout();
        Meteor.logout ()->
            Setup.logout();
            Session.set("spaceId", null);
            FlowRouter.go("/");


FlowRouter.route '/steedos/profile', 
    action: (params, queryParams)->
        if Meteor.userId()
            BlazeLayout.render 'masterLayout',
                main: "profile"


FlowRouter.route '/steedos/admin', 
    action: (params, queryParams)->
        if Meteor.userId()
            BlazeLayout.render 'masterLayout',
                main: "admin_home"


FlowRouter.route '/steedos/springboard', 
    action: (params, queryParams)->
        if !Meteor.userId()
            FlowRouter.go "/steedos/sign-in";
            return true

        Steedos.setAppId(null);

        NavigationController.reset();
        
        BlazeLayout.render 'masterLayout',
            main: "springboard"


FlowRouter.route '/steedos/space', 
    action: (params, queryParams)->
        if !Meteor.userId()
            FlowRouter.go "/steedos/sign-in";
            return true

        BlazeLayout.render 'masterLayout',
            main: "space_select"


FlowRouter.route '/steedos/space/info', 
    action: (params, queryParams)->
        if !Meteor.userId()
            FlowRouter.go "/steedos/sign-in";
            return true

        BlazeLayout.render 'masterLayout',
            main: "space_info"


FlowRouter.route '/steedos/help', 
    action: (params, queryParams)->
        locale = Steedos.getLocale()
        country = locale.substring(3)
        window.open("http://www.steedos.com/" + country + "/help/", '_blank', 'EnableViewPortScale=yes')

FlowRouter.route '/steedos/customize_apps',
    action: (params, queryParams)->
        spaceId = Steedos.getSpaceId()
        if spaceId
            space = db.spaces.findOne(spaceId)
            if !space?.is_paid
                swal(t("steedos_customize_apps"), t("steedos_only_paid"), "error")
            else
                FlowRouter.go("/admin/view/apps")

FlowRouter.route '/designer', 
    action: (params, queryParams)->
        if !Meteor.userId()
            FlowRouter.go "/steedos/sign-in";
            return true
        
        url = Meteor.absoluteUrl("applications/designer/current/" + Steedos.getLocale() + "/"+ "?spaceId=" + Steedos.getSpaceId());
        
        Steedos.openWindow(url);
        
        FlowRouter.go "/designer/opened"

FlowRouter.route '/designer/opened', 
    action: (params, queryParams)->
        if !Meteor.userId()
            FlowRouter.go "/steedos/sign-in";
            return true


FlowRouter.route '/app/:app_id', 

    # subscriptions: (params, queryParams) ->
    #     this.register('apps', Meteor.subscribe('apps'));
 
    action: (params, queryParams)->
        if !Meteor.userId()
            FlowRouter.go "/steedos/sign-in";
            return true
        
        app = db.apps.findOne(params.app_id)
        if !app
            FlowRouter.go("/steedos/springboard")
            return

        Steedos.setAppId params.app_id
        if app.is_use_ie
            if Steedos.isNode()
                exec = nw.require('child_process').exec
                path = "api/app/sso/#{params.app_id}?authToken=#{Accounts._storedLoginToken()}&userId=#{Meteor.userId()}"
                open_url = Meteor.absoluteUrl(path)
                cmd = "start iexplore.exe \"#{open_url}\""
                exec cmd, (error, stdout, stderr) ->
                    if error
                        toastr.error error
                    return
            FlowRouter.go "/app/#{params.app_id}/opened"
            return
        on_click = app.on_click
        if on_click
            # 这里执行的是一个不带参数的闭包函数，用来避免变量污染
            evalFunString = "(function(){#{on_click}})()"
            try
                eval(evalFunString)
            catch e
                # just console the error when catch error
                console.error "catch some error when eval the on_click script for app link:"
                console.error "#{e.message}\r\n#{e.stack}"
        else
            if app.internal
                FlowRouter.go(app.url)
                return

            if  params.app_id == 'mail'
                FlowRouter.go("/mail")
                return

            authToken = {};
            authToken["spaceId"] = Steedos.getSpaceId()
            if Steedos.isMobile()
                authToken["X-User-Id"] = Meteor.userId();
                authToken["X-Auth-Token"] = Accounts._storedLoginToken();

            url = Meteor.absoluteUrl("api/setup/sso/" + app._id + "?" + $.param(authToken));

            Steedos.openWindow(url);
            
        FlowRouter.go "/app/#{params.app_id}/opened"

FlowRouter.route '/app/:app_id/opened', 

    action: (params, queryParams)->
        if !Meteor.userId()
            FlowRouter.go "/steedos/sign-in";
            return true
        

FlowRouter.route '/steedos/sso', 
    action: (params, queryParams)->
        returnurl = queryParams.returnurl

        Steedos.loginWithCookie ()->
            Meteor._debug("cookie login success");
            FlowRouter.go(returnurl);


