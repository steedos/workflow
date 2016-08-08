MailManager = {};

MailManager.getImapClient = function(){
	var ImapClient = cos.require("emailjs-imap-client")
	return ImapClient;
}





