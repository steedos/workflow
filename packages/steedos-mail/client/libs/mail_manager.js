MailManager = {};

MailManager.getImapClient = function(){
	var ImapClient = cos.require("emailjs-imap-client")
	return ImapClient;
}

MailManager.getSmtpClient = function(){
	var ImapClient = cos.require("emailjs-smtp-client")
	return ImapClient;
}


MailManager.getBoxs = function(){
	
}
