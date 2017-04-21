_.extend Accounts,
	updatePhone: (number,callback)->
		if Meteor.isServer
			Meteor.call 'updatePhone', { number }
		if Meteor.isClient
			Meteor.call 'updatePhone', { number }, callback
	getPhoneNumber: (isIncludePrefix) ->
		number = Accounts.user()?.phone?.number
		if isIncludePrefix
			return number
		else
			number?.replace(/^\+86/,"")
