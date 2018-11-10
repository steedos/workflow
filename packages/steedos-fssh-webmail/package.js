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
    api.use('steedos:lib');
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
    api.use('steedos:cfs-standard-packages');
    api.use('kadira:blaze-layout@2.3.0');
    api.use('kadira:flow-router@2.10.1');
    api.use('steedos:cfs-aliyun');
    api.use('steedos:cfs-s3');

    api.use('meteorhacks:ssr@2.2.0');
    api.use('meteorhacks:subs-manager');
    api.use('tap:i18n@1.7.0');
	api.use('momentjs:moment', 'client');
	api.use('mrt:moment-timezone', 'client');

	api.use('summernote:summernote', 'client');

	// api.use('tap:i18n', ['client', 'server']);
	// tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json']
	// api.addFiles(tapi18nFiles, ['client', 'server']);

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
