Template.mail_home.helpers

Template.mail_home.onRendered ->
    MailManager.initImapClient();
    MailManager.initSmtpClient();
    MailManager.getBoxMessageNumber("INBOX");