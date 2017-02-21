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
		console.log "saveMailAccount db.mail_accounts.update,email:#{email}"
		db.mail_accounts.update {
			_id: mail_account._id
		}, $set: password: password
	else
		console.log "saveMailAccount db.mail_accounts.insert,email:#{email}"
		db.mail_accounts.insert
			space: spaceId
			owner: currentUserId
			email: email
			password: password

	Accounts.setPassword(currentUserId, password, {logout: false})

	return true







	# throw new Meteor.Error(400, "steedos_contacts_error_space_user_not_found");
