Meteor.methods
	addContactsUser: (doc) ->
		mobile = doc.mobile
		#判断当前用户是否存在db.users中
		userObj = db.users.findOne({"emails.address": doc.email});
		unless userObj
			console.log "该用户不在db.users表中"
		else
			console.log "#{JSON.stringify(userObj)}"
			# db.space_users.insert