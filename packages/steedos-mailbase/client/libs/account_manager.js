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
