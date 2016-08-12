Template.mail_home.helpers
    equals: (a,b) ->
        return (a == b)
        
Template.mail_home.onRendered ->
    MailManager.initImapClient();