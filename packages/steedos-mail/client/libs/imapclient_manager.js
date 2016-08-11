ImapClientManager = {};

ImapClientManager.ImapClient,ImapClientManager.ImapClientConnect;

ImapClientManager.init = function(){
	if(window.cos){
		var auth = MailManager.getAuth();
		var domain = MailManager.getMailDomain(auth.user);

		var ImapClient = cos.require("emailjs-imap-client")
		ImapClientManager.ImapClient = new ImapClient(domain.imap, domain.imap_port,{auth:auth});

		ImapClientManager.ImapClientConnect = ImapClientManager.ImapClient.connect();
	}
}
 
ImapClientManager.mailBox = function(){
	console.log("--run ImapClientManager.mailBox");
	ImapClientManager.ImapClientConnect.then(function(){
		ImapClientManager.ImapClient.listMailboxes().then(function(mailboxes){
			var children = mailboxes.children;
			children.forEach(function(box){
				console.log("mail_box insert : " + JSON.stringify(box))
				MailCollection.mail_box.insert(box);
			});

			ImapClientManager.mailboxInfo()
		});
	});
}

ImapClientManager.mailboxInfo = function(){
	console.log("--run ImapClientManager.mailboxInfo");
	ImapClientManager.ImapClientConnect.then(function(){
		mail_box = MailCollection.mail_box.find();
		console.log("--run ImapClientManager.mailboxInfo insert");
		console.log("mail_box count " + mail_box.count());
		mail_box.forEach(function(mb){
			ImapClientManager.ImapClient.selectMailbox(mb.path,{condstore:false,readOnly:true}).then(function(mailbox){
				mailbox.box = mb.name;
				mailbox.path = mb.path;
				console.log(mb.name + " selectMailbox is " + JSON.stringify(mailbox));
				MailCollection.mail_box_info.insert(mailbox);
			});
		})
	});
}

ImapClientManager.mailBoxMessages = function(){
	ImapClientManager.ImapClientConnect.then(function(){
		mail_box = MailCollection.mail_box.find();
		console.log("--run ImapClientManager.mailboxInfo insert");
		console.log("mail_box count " + mail_box.count());
		mail_box.forEach(function(mb){

			var sequence = "1:20";
			ImapClientManager.ImapClient.listMessages(mb.path, sequence, ['uid', 'flags', 'body[]','envelope','bodystructure']).then(function(mailbox){
				mailbox.box = mb.name;
				mailbox.path = mb.path;
				console.log(mb.name + " selectMailbox is " + JSON.stringify(mailbox));
				MailCollection.mail_box_info.insert(mailbox);
			});
		})
	});
}