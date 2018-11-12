checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in';

# checkMailAccountIsNull = (context, redirect) ->
# 	if !AccountManager.getAuth()
# 		FlowRouter.go '/admin/view/mail_accounts';
# 		toastr.warning("请配置邮件账户");
# 		$(document.body).removeClass('loading');

checkAccountLogin = (context, redirect) ->
	AccountManager.checkAccount()

fsshWebMailRoutes = FlowRouter.group
	prefix: '/fssh',
	name: 'mailRoute',
	triggersEnter: [ checkUserSigned],

fsshWebMailRoutes.route '/webmail',
	action: (params, queryParams)->
		BlazeLayout.render 'fsshWebLayout',
			main: "fsshWebmaill"

fsshWebMailRoutes.route '/mail_account',
	action: (params, queryParams)->
		BlazeLayout.render 'adminLayout',
			main: "webMailAccount"