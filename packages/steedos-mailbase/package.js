Package.describe({
	name: 'steedos:mailbase',
	version: '0.0.1',
	summary: 'Steedos mailbase',
	git: ''
});

Npm.depends({
});


Package.onUse(function(api) {

	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use('reactive-var');
	api.use('reactive-dict');
	api.use('coffeescript');
	api.use('random');
	api.use('ddp');
	api.use('check');
	api.use('ddp-rate-limiter');
	api.use('underscore');
	api.use('tracker');
	api.use('session');
	api.use('blaze');
	api.use('templating');
	api.use('modules');
	api.use('npm-bcrypt');
	api.use('steedos:base');
	api.use('steedos:ui');
	api.use('steedos:contacts');
	api.use('flemay:less-autoprefixer@1.2.0');
	api.use('simple:json-routes@2.1.0');
	api.use('nimble:restivus@0.8.7');
	api.use('aldeed:simple-schema@1.3.3');
	api.use('aldeed:collection2@2.5.0');
	api.use('aldeed:tabular@1.6.1');
	api.use('aldeed:autoform@5.8.0');
	api.use('matb33:collection-hooks@0.8.1');
	api.use('kadira:blaze-layout@2.3.0');
	api.use('kadira:flow-router@2.10.1');
	api.use('meteorhacks:ssr@2.2.0');
	api.use('meteorhacks:subs-manager');

	api.addFiles('server/publications/mail_accounts.coffee', 'server');
	api.addFiles('server/publications/mail_domains.coffee', 'server');
	
	api.addFiles('client/subcribe.coffee', 'client');
	
	api.addFiles('client/libs/account_manager.js', 'client');
	api.addFiles('client/libs/localhost_data.coffee', 'client');
	api.addFiles('client/libs/steedos-file.coffee', 'client');

	api.addFiles('lib/core.coffee', ['client', 'server']);
	api.addFiles('lib/models/mail_accounts.coffee', ['client', 'server']);
	api.addFiles('lib/models/mail_domains.coffee', ['client', 'server']);

	api.addFiles('lib/admin.coffee', ['client', 'server']);

	api.export('Mail');
	api.export('AccountManager');
});

Package.onTest(function(api) {

});
