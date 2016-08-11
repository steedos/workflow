MailManager = {};

MailManager.ImapClient, MailManager.ImapClientConnect, MailManager.SmtpClient, MailManager.SmtpClientConnect;

MailManager.getAuth = function(){
	return {user:"baozhoutao@hotoa.com",pass:"Bobtotal0106"};
}

MailManager.getMailDomain = function(user){
	return {domain:"@hotoa.com",imap:"imap.mxhichina.com",imap_port:143,smtp:"smtp.mxhichina.com",smtp_port:25}
}

MailManager.initImapClient = function(){
	if(window.cos){

		var auth = MailManager.getAuth();
		var domain = MailManager.getMailDomain(auth.user);

		var ImapClient = cos.require("emailjs-imap-client")
		MailManager.ImapClient = new ImapClient(domain.imap, domain.imap_port,{auth:auth});

		MailManager.ImapClientConnect = MailManager.ImapClient.connect();
	}
}

MailManager.initSmtpClient = function(){
	if(window.cos){

		var auth = MailManager.getAuth();
		var domain = MailManager.getMailDomain(auth.user);

		var SmtpClient = cos.require("emailjs-smtp-client")
		MailManager.SmtpClient = new SmtpClient(domain.smtp, domain.smtp_port,{auth:auth});

		MailManager.SmtpClientConnect = MailManager.SmtpClient.connect();
	}
}

MailManager.getBoxList = function(){

}

MailManager.getBoxMessageNumber = function(boxName){
	var rev = 0;
	MailManager.ImapClientConnect.then(function(){
		MailManager.ImapClient.selectMailbox(boxName).then(function(mailbox){
			console.log(boxName + " selectMailbox " + JSON.stringify(mailbox));
			rev = mailbox.exists
			Session.set("mail_inbox_exists",mailbox.exists)
			console.log("rev is " + rev);
		});
	});
	console.log("return rev is " + rev);
	return rev;
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
	return getMessages(MailCollection.mail_inbox_messages, page, page_size);
}

MailManager.getMessage = function(id){
	return MailCollection.mail_inbox_messages.findOne(id);
}

MailManager.search = function(query){

}


