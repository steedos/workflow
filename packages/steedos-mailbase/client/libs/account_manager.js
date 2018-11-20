AccountManager = {_auth: null};

_AccountsRemote = new AjaxCollection("mail_accounts")

AccountManager.getAuth = function(){
	if(!_.isEmpty(AccountManager._auth)){
		return AccountManager._auth;
	}
	var mail_account = _AccountsRemote.findOne();
	// console.log('mail_account', mail_account);
	if(!mail_account)
		return ;
	AccountManager._auth = {user: mail_account.email,pass: mail_account.password};
	return AccountManager._auth;
}

AccountManager.getMailDomain = function(user){
	user_domain = user.split("@")[1];
	return db.mail_domains.findOne({domain: user_domain});
	// return {domain:"@hotoa.com",imap:"imap.mxhichina.com",imap_port:143,smtp:"smtp.mxhichina.com",smtp_port:25}
	//return {domain:"@petrochina.com.cn",imap:"msg.petrochina.com.cn",imap_port:993,smtp:"msg.petrochina.com.cn",smtp_port:465}
}

AccountManager.checkAccount = function(callback){

	$(document.body).addClass('loading');
	try{
		console.log("AccountManager.checkAccount...");
		var userAuth = AccountManager.getAuth();

		if(!userAuth){
			// toastr.error("请配置邮件账户");
			try{
				if(callback){
					if(typeof(callback) == 'function'){
						callback("未配置邮件账户");
					}
				}
			}catch(e){
				$(document.body).removeClass('loading');
				console.error("AccountManager.checkAccount callback function error:" + e);
			}

			return false;
		}

		if(!AccountManager.getMailDomain(userAuth.user)){

			// toastr.error("账户验证失败, 无效的邮件域名");
			try{
				if(callback){
					if(typeof(callback) == 'function'){
						callback("账户验证失败, 无效的邮件域名");
					}
				}
			}catch(e){
				console.error("AccountManager.checkAccount callback function error:" + e);
			}

			$(document.body).removeClass('loading');

			return false;
		}

		var imapClient = ImapClientManager.getClient(userAuth);
		var pro = imapClient.connect();

		pro.then(function(){

			imapClient.close();
			console.log("账户验证完成" + Date.parse(new Date()));

			var email_accounts = null;
			if(MailCollection.email_accounts)
				email_accounts = MailCollection.email_accounts.findOne({account:userAuth.user});

			if(!email_accounts){

				Session.set("email_account", userAuth.user);

				MailCollection.destroy();

				MailCollection.create("email_accounts");

				LocalhostData.userFolder = LocalhostData.mkdirFolder(Session.get('email_account'));

				LocalhostData.userInboxFolder = LocalhostData.mkdirFolder("inbox", LocalhostData.userFolder);
				LocalhostData.userDraftFolder = LocalhostData.mkdirFolder("draft", LocalhostData.userFolder);

				MailCollection.email_accounts.insert({});

				MailManager.initMail(callback);

				// 自动清理一周前本地缓存的附件
				LocalhostData.rmdir(LocalhostData.userInboxFolder);
			}else{
				try{
					if(callback){
						if(typeof(callback) == 'function'){
							callback("");
						}
					}
				}catch(e){
					console.error("AccountManager.checkAccount callback function error:" + e);
				}
				$(document.body).removeClass('loading');
			}
		});

		pro.catch(function(err){
			imapClient.close();
			// FlowRouter.go('/admin/view/mail_accounts');
			try{
				if(callback){
					if(typeof(callback) == 'function'){
						callback("账户验证失败");
					}
				}
			}catch(e){
			  console.error("AccountManager.checkAccount callback function error:" + e);
			}
			$(document.body).removeClass('loading');

		});
	}catch(e){
		toastr.error("账户验证失败，错误信息：" + e.message);
		$(document.body).removeClass('loading');
		return false;
	}

	return true;
}
