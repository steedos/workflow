
Accounts.emailTemplates = {
  from: "Meteor Accounts <no-reply@meteor.com>",
  // siteName: Meteor.absoluteUrl().replace(/^https?:\/\//, '').replace(/\/$/, ''),

  resetPassword: {
    subject: function (user) {
      return trl("users_email_reset_password",{},user.locale);
    },
    text: function (user, url) {
      var splits = url.split("/");
      var tokenCode = splits[splits.length-1];
      var greeting = user.profile && user.profile.name ? trl("users_email_hello",{},user.locale) + user.profile.name + "," : trl("users_email_hello",{},user.locale) + ",";
      return greeting + "\n\n" + trl("users_email_reset_password_body",tokenCode,user.locale) + "\n\n" + url + "\n\n" + trl("users_email_thanks",{},user.locale) + "\n";
    }
  },
  verifyEmail: {
    subject: function (user) {
      return trl("users_email_verify_email",{},user.locale);
    },
    text: function (user, url) {
      var greeting = user.profile && user.profile.name ? trl("users_email_hello",{},user.locale) + user.profile.name + "," : trl("users_email_hello",{},user.locale) + ",";
      return greeting + "\n\n" + trl("users_email_verify_account",{},user.locale) + "\n\n" + url + "\n\n" + trl("users_email_thanks",{},user.locale) + "\n";
    }
  },
  enrollAccount: {
    subject: function (user) {
      return trl("users_email_create_account",{},user.locale);
    },
    text: function (user, url) {
      var greeting = user.profile && user.profile.name ? trl("users_email_hello",{},user.locale) + user.profile.name + "," : trl("users_email_hello",{},user.locale) + ",";
      return greeting + "\n\n" + trl("users_email_start_service",{},user.locale) + "\n\n" + url + "\n\n" + trl("users_email_thanks",{},user.locale) + "\n";
    }
  }
};