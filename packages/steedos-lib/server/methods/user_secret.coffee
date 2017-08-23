Meteor.methods
	create_secret: (name)->
		if !this.userId
			return false;

		secretToken =  Accounts._generateStampedLoginToken()

		secretToken.token = this.userId + "-" + secretToken.token

		hashedToken = Accounts._hashLoginToken(secretToken.token)

		secretToken.hashedToken = hashedToken

		secretToken.name = name

		db.users.update({_id: this.userId}, {$push: {secrets: secretToken}})

	remove_secret: (token)->
		if !this.userId || !token
			return false;

		hashedToken = Accounts._hashLoginToken(token)

		console.log("token", token)

		db.users.update({_id: this.userId}, {$pull: {"secrets": {hashedToken: hashedToken}}})
