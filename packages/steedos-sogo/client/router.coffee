checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in';

checkAccountLogin = (context, redirect) ->
	AccountManager.checkAccount()

sogoRoutes = FlowRouter.group
	prefix: '/sogo',
	name: 'mailRoute',
	triggersEnter: [ checkUserSigned],

sogoRoutes.route '/',
	action: (params, queryParams)->
		BlazeLayout.render 'sogoLayout',
			main: "sogoWeb"

FlowRouter.route '/admin/mail_account',
	triggersEnter: [ checkUserSigned],
	action: (params, queryParams)->
		BlazeLayout.render 'adminLayout',
			main: "webMailAccount"


Meteor.startup ->
	AutoForm.hooks
		updateMailAccount:
			onSuccess: (formType, result) ->
				toastr.success t('saved_successfully');
				AccountManager._auth = null;
			onError: (formType, error) ->
				if error.reason
					toastr.error error.reason
				else
					toastr.error error