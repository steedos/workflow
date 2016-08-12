Template.mail_list.helpers
    box: ->
        return Session.get("mailBox")

    boxName: ->
        if Session.get("mailBox")
            console.log("mail_" + Session.get("mailBox"));
            console.log(t("mail_" + Session.get("mailBox")));
            return t("mail_" + Session.get("mailBox"))
        else
            return t("mail_inbox")

    boxMessages: ->
        return MailManager.getboxMessages(0,10);


    modifiedString: (date)->
        modifiedString = moment(date).format('YYYY-MM-DD');
        return modifiedString;

    modifiedFromNow: (date)->
        modifiedFromNow = moment(date).fromNow();
        return modifiedFromNow;

    haveAttachment: (attachments)->
        if attachments.length > 0
            return true;
        return false;


    


