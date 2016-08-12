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
		ImapClientManager.init();
		ImapClientManager.mailBox();
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

MailManager.getBoxInfo = function(path){
	return MailCollection.mail_box_info.findOne({path: path})
}

MailManager.getBox = function(path){
	var box = MailCollection.mail_box.findOne({path: path})
	box.info = MailManager.getBoxInfo(box.path);
	console.log(box);
	return box;
}

MailManager.getBoxBySpecialUse = function(specialUse){
	var box = MailCollection.mail_box.findOne({specialUse: specialUse})
	box.info = MailManager.getBoxInfo(box.path);
	console.log(box);
	return box;
}


MailManager.getBoxs = function(){
	return MailCollection.mail_box.find().fetch();
}


function getMessages (collection, page, page_size){

	// var mails = new Array();

	// if (!collection)
	// 	return mails;

	// collection.find({},{sort: {uid:1}, skip:page*page_size,limit:page_size}).forEach(function(message){
	// 	mails.push(message);
	// })

	// return mails;

	return collection.find({},{sort: {uid:1}, skip: page * page_size, limit: page_size}).fetch();
}


MailManager.getboxMessages = function(page, page_size){
	if (!MailCollection)
		return;
	return getMessages(MailCollection.getMessageCollection(Session.get("mailBox")), page, page_size);
}

MailManager.getMessage = function(id){
	return MailCollection.getMessageCollection(Session.get("mailBox")).findOne(id);
}

MailManager.search = function(query){

}


