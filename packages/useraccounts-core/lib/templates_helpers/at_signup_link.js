AT.prototype.atSignupLinkHelpers = {
    disabled: function() {
        return AccountsTemplates.disabled();
    },
    signUpLink: function(){
        // return AccountsTemplates.getRoutePath("signUp");
        // 注册界面重写
        return "/steedos/admin/register";
    },
    preText: function(){
        return T9n.get(AccountsTemplates.texts.signUpLink_pre, markIfMissing=false);
    },
    linkText: function(){
        return T9n.get(AccountsTemplates.texts.signUpLink_link, markIfMissing=false);
    },
    suffText: function(){
        return T9n.get(AccountsTemplates.texts.signUpLink_suff, markIfMissing=false);
    },
};

AT.prototype.atSignupLinkEvents = {
    "click #at-signUp": function(event, t) {
        event.preventDefault();
        // AccountsTemplates.linkClick('signUp');
        // 注册界面重写
        FlowRouter.go("/steedos/admin/register")
    },
};
