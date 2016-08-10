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


function getMessages (collection, page, page_size){

	var mails = new Array();

	if (!collection)
		return mails;

	collection.find({},{skip:page*page_size,limit:page_size}).forEach(function(message){
		mails.push(message);
	})

	return mails;
}


MailManager.getInboxMessages = function(page, page_size){
	if (!MailCollection)
		return;
	return getMessages(MailCollection.inbox_messages, page, page_size);
}


