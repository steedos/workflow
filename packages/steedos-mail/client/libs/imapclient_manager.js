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

	ImapClientManager.ImapClientConnect.then(function(){
		ImapClientManager.ImapClient.listMailboxes().then(function(mailboxes){
			var children = mailboxes.children;
			children.forEach(function(c){
				console.log("mail_box insert : " + JSON.stringify(c))
				MailCollection.mail_box.insert(c);
			});
		});
	});


	
}

ImapClientManager.mailboxInfo = function(){
	ImapClientManager.ImapClientConnect.then(function(){
		mail_box = MailCollection.mail_box.find();
		mail_box.forEach(function(mb){

			ImapClientManager.ImapClient.selectMailbox(mb).then(function(mailbox){
				
				console.log(mb + " selectMailbox is " + JSON.stringify(mailbox));
			});
		})
	});
}