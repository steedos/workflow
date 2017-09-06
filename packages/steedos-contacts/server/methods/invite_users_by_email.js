Meteor.methods({
	invite_users_by_email: function(emails, space_id, org_ids) {
		check(emails, Array);
		check(space_id, String);
		check(org_ids, Array);

		var s = db.spaces.findOne({
			_id: space_id
		}, {
			fields: {
				is_paid: 1,
				user_limit: 1
			}
		});
		var accepted_user_count = db.space_users.find({
			space: space_id,
			user_accepted: true
		}).count();
		if (s.is_paid == true) {
			if ((emails.length + accepted_user_count) > s.user_limit) {
				var c = (emails.length + accepted_user_count) - s.user_limit;
				throw new Meteor.Error(400, "需要额外购买" + c + "个用户名额");
			}
		}

		emails.forEach(function(email) {
			var su_obj = {};
			su_obj.email = email;
			su_obj.name = email.split("@")[0];
			su_obj.organizations = org_ids;
			su_obj.space = space_id;
			su_obj.user_accepted = true;

			db.space_users.insert(su_obj);
		})

		return true;
	}
})