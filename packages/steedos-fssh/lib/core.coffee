FSSH = 
	checkAccount: (userAuth, callback)->
		try
			if !AccountManager.getMailDomain(userAuth.user)
				callback {reason:'账户验证失败, 无效的邮件域名'},false
				return
			imapClient = ImapClientManager.getClient(userAuth)
			pro = imapClient.connect()
			pro.then ->
				imapClient.close()
				callback null,true
			pro.catch (err) ->
				imapClient.close()
				callback {reason:'账户验证失败'},false
		catch e
			callback {reason:'账户验证失败',message:e.message},false

# 不允许注册新用户
AccountsTemplates.options.forbidClientAccountCreation = true