Meteor.methods({
	import_users_from_contacts: function(users, groupId, spaceId) {
		check(users, Array);
		check(groupId, String);
		check(spaceId, String);
		
		// 将每个人员导入到选中的分组中
		users.forEach(function(user){
			var sUser = db.space_users.findOne({space: spaceId, user: user});
			if(sUser){
				var bUser = db.address_books.find({group: groupId, email: sUser.email})
				// 不重复添加已存在的联系人
				// if (bUser.count() == 0){
				db.address_books.insert({
					owner: Meteor.userId(),
					group: groupId,
					name: sUser.name,
					email: sUser.email
				})
				// }
			}
		})
		return true;
	}
})