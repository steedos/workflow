Package.describe({
	name: 'steedos:sogo',
	version: '0.0.1',
	summary: 'Steedos sogo',
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

	api.use('steedos:mailbase@0.0.1');

	api.addFiles('client/core.coffee', 'client');
	api.addFiles('client/notification.coffee', 'client');
	api.addFiles('client/router.coffee', 'client');

	api.addFiles('client/layout/master.html', 'client');
	api.addFiles('client/layout/master.coffee', 'client');
	api.addFiles('client/layout/master.less', 'client');

	api.addFiles('client/sogo-web.html', 'client');
	api.addFiles('client/sogo-web.coffee', 'client');

	api.addFiles('client/mail_account.html', 'client');
	api.addFiles('client/mail_account.coffee', 'client');
	
	api.addFiles('client/admin_menu.coffee', 'client');
});

Package.onTest(function(api) {

});
