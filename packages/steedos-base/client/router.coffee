FlowRouter.route '/steedos/sign-out', 
	action: (params, queryParams)->
		Meteor.logout ()->
			Session.set("spaceId", null);
			FlowRouter.go("/");
