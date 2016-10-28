Meteor.methods({
	invite_users_by_email: function(emails, space_id, org_ids) {
		check(emails, Array);
		check(space_id, String);
		check(org_ids, Array);

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