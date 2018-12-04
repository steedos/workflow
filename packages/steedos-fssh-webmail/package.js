Package.describe({
	name: 'steedos:fssh-webmail',
	version: '0.0.1',
	summary: 'Steedos fssh webMail',
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
	api.use('ddp');
	api.use('check');
	api.use('ddp-rate-limiter');
	api.use('underscore');
	api.use('tracker');
    api.use('blaze');
    api.use('templating');
    api.use('modules');
    api.use('npm-bcrypt');
    api.use('steedos:base');
    api.use('flemay:less-autoprefixer@1.2.0');
    api.use('simple:json-routes@2.1.0');
    api.use('nimble:restivus@0.8.7');
    api.use('kadira:blaze-layout@2.3.0');
    api.use('kadira:flow-router@2.10.1');
    api.use('meteorhacks:ssr@2.2.0');
    api.use('meteorhacks:subs-manager');


	api.addFiles('client/subcribe.coffee', 'client');
	api.addFiles('client/router.coffee', 'client');

	api.addFiles('client/layout/master.html', 'client');
	api.addFiles('client/layout/master.coffee', 'client');
	api.addFiles('client/layout/master.less', 'client');

	api.addFiles('client/fssh-webmail.html', 'client');
	api.addFiles('client/fssh-webmail.coffee', 'client');
});

Package.onTest(function(api) {

});
