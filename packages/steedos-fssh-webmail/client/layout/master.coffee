Template.fsshWebLayout.onCreated ->
  self = this;
  # $(window).resize ->
  #     if $(window).width()<=1200
  #         $("body").addClass("sidebar-collapse")
  #     else
  #         $("body").removeClass("sidebar-collapse")

Template.fsshWebLayout.onRendered ->
  # $(window).resize();
  Tracker.afterFlush ->
    $("body").removeClass("sidebar-collapse")


Template.fsshWebLayout.helpers
    subsReady: ->
        if Steedos.subsMail.ready() && Session.get("spaceId")
            unless Meteor.userId()
              return false
            if Meteor.loggingIn()
              # 正在登录中，则不做处理，因为此时Meteor.userId()不足于证明已登录状态
              return false
            return true;
        return false;

Template.fsshWebLayout.events
    "click #navigation-back": (e, t) ->
        NavigationController.back(); 
