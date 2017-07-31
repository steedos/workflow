// Accounts.oauth.registerService('bqq');

if (Meteor.isClient) {
	Meteor.loginWithBqq = function(options, callback) {
		// support a callback without options
		if (!callback && typeof options === "function") {
			callback = options;
			options = null;
		}

		var credentialRequestCompleteCallback = Accounts.oauth.credentialRequestCompleteHandler(callback);
		BQQ.requestCredential(options, credentialRequestCompleteCallback);
	};
} else {
	Accounts.addAutopublishFields({
		forLoggedInUser: ['services.bqq'],
		forOtherUsers: ['services.bqq.nickname']
	});
}