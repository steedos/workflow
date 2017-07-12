FlowRouter.route '/steedos/logout', 
	action: (params, queryParams)->
		#AccountsTemplates.logout();
		$("body").addClass('loading')
		Meteor.logout ()->
			Setup.logout();
			Session.set("spaceId", null);
			$("body").removeClass('loading')
			FlowRouter.go("/");