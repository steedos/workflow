
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
            appId = Steedos.getAppId()
            if !appId
                FlowRouter.go("/steedos/springboard")
            else
                FlowRouter.go("/app/" + appId);
        

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

        on_click = app.on_click
        if on_click
            # url = "​http://mail.steedos.com/"
            # form = "<form class=\"wrapper loginForm thm-login\" action=\"#/\" data-bind=\"submit: submitForm\"><div class=\"controls\" data-bind=\"css: {'error': emailError}\"><div class=\"input-append\"><input type=\"email\" class=\"i18n input-block-level inputEmail checkAutocomplete\" name=\"RainLoopEmail\" id=\"RainLoopEmail\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\" data-bind=\"textInput: email, hasFocus: emailFocus\" data-i18n-placeholder=\"LOGIN/LABEL_EMAIL\" placeholder=\"Email\"><span class=\"add-on\"><i class=\"icon-mail\"></i></span></div></div><div class=\"controls\" data-bind=\"css: {'error': passwordError}\"><div class=\"input-append\"><input type=\"password\" class=\"i18n input-block-level inputPassword checkAutocomplete\" name=\"RainLoopPassword\" id=\"RainLoopPassword\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\" data-bind=\"textInput: password, hasFocus: passwordFocus\" data-i18n-placeholder=\"LOGIN/LABEL_PASSWORD\" placeholder=\"Password\"><span class=\"add-on\"><i class=\"icon-key\"></i></span></div></div><div class=\"controls\" data-bind=\"visible: additionalCode.visibility(), css: {'error': additionalCode.error}\" style=\"display: none;\"><div class=\"input-append\"><input type=\"text\" class=\"i18n input-block-level inputAdditionalCode\" autocomplete=\"off\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\" data-bind=\"textInput: additionalCode, hasFocus: additionalCode.focused\" data-i18n-placeholder=\"LOGIN/LABEL_VERIFICATION_CODE\" placeholder=\"Verification Code\"><span class=\"add-on\"><i class=\"icon-key\"></i></span></div></div><div class=\"controls\" data-bind=\"visible: additionalCode.visibility()\" style=\"display: none;\"><label class=\"additionalCodeSignMeLabel\" data-bind=\"click: function () { additionalCodeSignMe(!additionalCodeSignMe()); }\"><i data-bind=\"css: additionalCodeSignMe() ? 'checkboxAdditionalCodeSignMe icon-checkbox-checked' : 'checkboxAdditionalCodeSignMe icon-checkbox-unchecked'\" class=\"checkboxAdditionalCodeSignMe icon-checkbox-unchecked\"></i>&nbsp;&nbsp;<span class=\"i18n\" data-i18n-text=\"LOGIN/LABEL_DONT_ASK_VERIFICATION_CODE\">Don't ask for the code for 2 weeks</span></label></div><div class=\"controls\"><button type=\"submit\" class=\"btn btn-large btn-block buttonLogin command no-disabled\" data-bind=\"command: submitCommand, hasFocus: submitFocus\"><i class=\"icon-spinner animated\" data-bind=\"visible: submitRequest\" style=\"display: none;\"></i><span class=\"i18n i18n-animation\" data-i18n-text=\"LOGIN/BUTTON_SIGN_IN\" data-bind=\"visible: !submitRequest()\">Sign In</span></button></div><div class=\"controls\"><div class=\"pull-right social-buttons\"><a href=\"#\" tabindex=\"-1\" class=\"social-button command command-can-not-be-execute command-disabled disable disabled\" data-bind=\"visible: facebookLoginEnabled, command: facebookCommand, tooltip: 'LOGIN/TITLE_SIGN_IN_FACEBOOK'\" style=\"display: none;\" data-original-title=\"\" title=\"\"><i class=\"icon-facebook-alt\"></i></a><a href=\"#\" tabindex=\"-1\" class=\"social-button command command-can-not-be-execute command-disabled disable disabled\" data-bind=\"visible: googleLoginEnabled, command: googleCommand, tooltip: 'LOGIN/TITLE_SIGN_IN_GOOGLE'\" style=\"display: none;\" data-original-title=\"\" title=\"\"><i class=\"icon-google\"></i></a><a href=\"#\" tabindex=\"-1\" class=\"social-button command command-can-not-be-execute command-disabled disable disabled\" data-bind=\"visible: twitterLoginEnabled, command: twitterCommand, tooltip: 'LOGIN/TITLE_SIGN_IN_TWITTER'\" style=\"display: none;\" data-original-title=\"\" title=\"\"><i class=\"icon-twitter\"></i></a><a href=\"#\" tabindex=\"-1\" class=\"language-button\" data-bind=\"visible: allowLanguagesOnLogin() &amp;&amp; !socialLoginEnabled(), click: selectLanguage, tooltip: 'POPUPS_LANGUAGES/TITLE_LANGUAGES'\" data-original-title=\"\" title=\"\"><i data-bind=\"css: langRequest() ? 'icon-spinner animated' : 'icon-world'\" class=\"icon-world\"></i></a></div><label class=\"signMeLabel inline\" data-bind=\"click: function () { signMe(!signMe()); }, visible: signMeVisibility\"><i data-bind=\"css: signMe() ? 'checkboxSignMe icon-checkbox-checked' : 'checkboxSignMe icon-checkbox-unchecked'\" class=\"checkboxSignMe icon-checkbox-unchecked\"></i>&nbsp;&nbsp;<span class=\"i18n i18n-animation\" data-i18n-text=\"LOGIN/LABEL_SIGN_ME\">Remember Me</span></label></div><div class=\"controls clearfix\" data-bind=\"visible: '' !== forgotPasswordLinkUrl || '' !== registrationLinkUrl\" style=\"display: none;\"><div class=\"forgot-link thm-forgot pull-left\" data-bind=\"visible: '' !== forgotPasswordLinkUrl\" style=\"text-align: center; display: none;\"><a href=\"\" target=\"_blank\" class=\"g-ui-link\" data-bind=\"attr: {href: forgotPasswordLinkUrl}, css: {'pull-right': '' !== registrationLinkUrl}\"><span class=\"i18n\" data-i18n-text=\"LOGIN/LABEL_FORGOT_PASSWORD\">Forgot password</span></a></div>&nbsp;<div class=\"registration-link thm-registration pull-right\" data-bind=\"visible: '' !== registrationLinkUrl\" style=\"text-align: center; display: none;\"><a href=\"\" target=\"_blank\" class=\"g-ui-link\" data-bind=\"attr: {href: registrationLinkUrl}, css: {'pull-left': '' !== forgotPasswordLinkUrl}\"><span class=\"i18n\" data-i18n-text=\"LOGIN/LABEL_REGISTRATION\">Registration</span></a></div></div></form>"
            # $('#isso').remove()
            # $frame = $('<iframe name="isso" id="isso" scrolling="no" style="display:none">')
            # $demo = $(form)
            # $('body').append $frame
            # setTimeout (->
            #   $('#isso').contents().find('body').html $demo
            #   #创建表单
            #   $('#isso').contents().find('form').submit()
            #   debugger
            #   window.open "​http://mail.steedos.com/"
            #   #提交表单
            #   # $.ajax
            #   #   type: 'get'
            #   #   dataType: 'jsonp'
            #   #   cache: false
            #   #   url: 'http://expense.cnpc/Expense/Service/ExpenseWebService.asmx/UserLogOn'
            #   return
            # ), 2000
            # 这里执行的是一个不带参数的闭包函数，用来避免变量污染
            evalFunString = "(function(){#{on_click}})()"
            try
                eval(evalFunString)
            catch e
                # just console the error when catch error
                console.error "catch some error when eval the on_click script for app link:"
                console.error "#{e.message}\r\n#{e.stack}"

        Steedos.setAppId(params.app_id);

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


