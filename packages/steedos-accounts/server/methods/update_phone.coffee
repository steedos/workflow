Phone = Npm.require('phone')

Meteor.methods updatePhone: (options) ->
	check options, Object
	{ number } = options
	check number, String

	number = Phone(number)[0]
	unless number
		throw new Meteor.Error(403, "Not a valid phone")
		return false

	currentUserId = @userId
	unless currentUserId
		return true

	currentUser = Accounts.user()
	currentNumber = currentUser.phone?.number
	if currentNumber
		if currentNumber != number
			db.users.update {
				_id: currentUserId
			}, $set: phone: {number: number, verified: false}
	else
		db.users.update {
			_id: currentUserId
		}, $set: phone: {number: number, verified: false}


	return true


