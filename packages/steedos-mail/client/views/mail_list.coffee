Template.mail_list.helpers
    box: ->
        return Session.get("mailBox")

    messageId: ->
        return "1234567890"

    boxName: ->
        if Session.get("mailBox")
            console.log("mail_" + Session.get("mailBox"));
            console.log(t("mail_" + Session.get("mailBox")));
            return t("mail_" + Session.get("mailBox"))
        else
        	return t("mail_inbox")