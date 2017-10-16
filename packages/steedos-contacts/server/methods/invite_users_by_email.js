Meteor.methods({
	invite_users_by_email: function(emails, space_id, org_ids) {
		check(emails, Array);
		check(space_id, String);
		check(org_ids, Array);

		emails.forEach(function(email) {
			var is_create = false;

			var user = db.users.findOne({
				"emails.address": email
			}, {
				fields: {
					services: 1,
					emails: 1
				}
			});

			if (user) {
				var existed = db.space_users.find({
					"user": user._id,
					"space": space_id
				});

				if (existed.count() > 0) {
					if (!user.services || !user.services.password || !user.services.password.bcrypt) {
						// 发送让用户设置密码的邮件
						Accounts.sendEnrollmentEmail(user._id, user.emails[0].address)
					}
				} else {
					is_create = true;
				}
			} else {
				is_create = true;
			}

			if (is_create) {
				var su_obj = {};
				su_obj.email = email;
				su_obj.name = email.split("@")[0];
				su_obj.organizations = org_ids;
				su_obj.space = space_id;
				su_obj.user_accepted = true;

				db.space_users.insert(su_obj);
			}

		})

		return true;
	}
})