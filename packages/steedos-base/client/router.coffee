checkUserSigned = (context, redirect) ->
	if !Meteor.userId()
		FlowRouter.go '/steedos/sign-in';

FlowRouter.route '/steedos/logout',
	action: (params, queryParams)->
		#AccountsTemplates.logout();
		$("body").addClass('loading')
		Meteor.logout ()->
			Setup.logout();
			Session.set("spaceId", null);
			$("body").removeClass('loading')
			FlowRouter.go("/");

FlowRouter.route '/apps/iframe/:app_id',
	triggersEnter: [ checkUserSigned ],
	action: (params, queryParams)->
		authToken = {};
		authToken["spaceId"] = Steedos.getSpaceId()
		authToken["X-User-Id"] = Meteor.userId()
		authToken["X-Auth-Token"] = Accounts._storedLoginToken()
		url = Meteor.absoluteUrl("api/setup/sso/" + params.app_id + "?" + $.param(authToken))

		BlazeLayout.render 'iframeLayout',
			url: url


FlowRouter.route '/steedos/springboard',
	triggersEnter: [ ->
		FlowRouter.go "/"
	]
