Template.mail_list.helpers
    box: ->
        return Session.get("box")

    messageId: ->
        return "1234567890"

    boxName: ->
        if Session.get("box")
            console.log("mail_" + Session.get("box"));
            console.log(t("mail_" + Session.get("box")));
            return t("mail_" + Session.get("box"))