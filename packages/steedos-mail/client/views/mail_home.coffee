Template.mail_home.helpers

Template.mail_home.onRendered ->
    debugger;
    MailManager.initImapClient();
    MailManager.initSmtpClient();
    