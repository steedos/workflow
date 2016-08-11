ImapClientManager = {};

ImapClientManager.ImapClient,ImapClientManager.ImapClientConnect;

var mimeParser, encoding;

ImapClientManager.init = function(){
	if(window.cos){
		var auth = MailManager.getAuth();
		var domain = MailManager.getMailDomain(auth.user);

		var ImapClient = cos.require("emailjs-imap-client")
		ImapClientManager.ImapClient = new ImapClient(domain.imap, domain.imap_port,{auth:auth});

		ImapClientManager.ImapClientConnect = ImapClientManager.ImapClient.connect();


		mimeParser  = cos.require('emailjs-mime-parser');
		encoding = cos.require('emailjs-stringencoding');

		return true;
	}
	return false;
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
	var b = 100;
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

function uint8ArrayToString(charset, uint8Array){
	return (new encoding.TextDecoder(charset).decode(uint8Array));
}

function handerMessage(message){
	var rev = {};

	var envelope = message["envelope"];
	rev.uid = message.uid;
	rev.flags = message.flags;
	rev.date =envelope.date;
	rev.subject = envelope.subject;
	rev.from = envelope.from;
	rev.sender = envelope.sender;
	rev.reply_to = envelope["reply-to"];
	rev.to = envelope.to;
	rev.cc = envelope.cc;
	rev.bcc = envelope.bcc;
	rev.in_reply_to = envelope["in-reply-to"];
	rev.message_id  = envelope["message-id"];

	var bodystructure = message["bodystructure"];
	var bodyMime = message["body[]"];
	var parser = new mimeParser();

	parser.write(bodyMime);
	parser.end();

	var attachments = new Array(), bodyText = "", bodyHtml = "";

	if(bodystructure){

		bodystructure.childNodes.forEach(function(bs, index){
			
			var node = parser.nodes["node"+(index+1)];

			if(bs.disposition == 'attachment'){
				var attachment = new Object();
				attachment.name = bs.dispositionParameters.filename;
				attachment.data = uint8ArrayToString("utf-8",node.content);
				attachments.push(attachment);
			}else{
	    		if(bs.type == 'multipart/alternative'){

	    			bodyText = uint8ArrayToString(node._childNodes[0].charset,node._childNodes[0].content);
	    			bodyHtml = uint8ArrayToString(node._childNodes[1].charset,node._childNodes[1].content);

	    		}else if(bs.type == 'text/plain'){

	    			bodyText = uint8ArrayToString(node.charset,node.content);

	    		}else if(bs.type == 'text/html'){

	    			bodyHtml = uint8ArrayToString(node.charset,node.content);

	    		}
			}
		});

	}

	rev.bodyText = bodyText;
	rev.bodyHtml = bodyHtml;
	rev.attachments = attachments;

	return rev;
}

ImapClientManager.mailBoxMessages = function(boxName, sequence){
	ImapClientManager.ImapClientConnect.then(function(){
		ImapClientManager.ImapClient.listMessages(boxName, sequence, ['uid', 'flags', 'body[]','envelope','bodystructure']).then(function(messages){
			
			messages.forEach(function(message){
				var hMessage = handerMessage(message);
				console.log(hMessage);
			});

		});
	});
}