Meteor.methods
	addContactsUser: (doc) ->
		mobile = doc.mobile
		spaceId = doc.space
		#判断当前用户是否存在db.users中
		userObj = db.users.findOne({"emails.address": doc.email});
		userId = userObj._id
		isInThisSpace = db.space_users.findOne({user: userId, space: spaceId})
		if isInThisSpace
			console.log "该用户已存在"
		else
			console.log "该用户不存在"
		# unless userObj
		# 	console.log "该用户不在db.users表中"
		# else
		# 	doc.mobile = userObj.mobile

			# db.space_users.insert