Meteor.methods saveMailAccount: (options) ->
	check options, Object
	{ spaceId, email, password } = options
	check spaceId, String
	check email, String
	check password, String

	currentUserId = @userId
	unless currentUserId
		return true

	mail_account = db.mail_accounts.findOne({owner:currentUserId})
	if mail_account
		db.mail_accounts.update {
			_id: mail_account._id
		}, $set: password: password
	else
		db.mail_accounts.insert
			space: spaceId
			owner: currentUserId
			email: email
			password: password

	Accounts.setPassword(currentUserId, password, {logout: false})

	currentUser = Accounts.user()
	if currentUser.emails?.length > 0
		currentEmail = currentUser.emails.findPropertyByPK("address",email)
		unless currentEmail.verified
			# 把当前邮件地址对应的邮件verified设置为true
			db.users.update {
				_id: currentUserId
				"emails.address": email
			}, $set: 
					"emails.$.verified": true,
					"email": email,
					"steedos_id": email


	return true


