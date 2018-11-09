Steedos.subsMail = new SubsManager();

Steedos.subsMail.subscribe "mail_domains"

Tracker.autorun (c)->
    if Meteor.userId()
        Steedos.subsMail.subscribe "mail_accounts"
        
 