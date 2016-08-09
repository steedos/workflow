Package.describe({
	name: 'steedos:mail',
	version: '0.0.1',
	summary: 'Steedos Mail',
	git: ''
});

Npm.depends({
	busboy: "0.2.13",
	cookies: "0.6.1",
	mime: "1.3.4"
});


Package.onUse(function(api) { 

	api.versionsFrom('1.0');

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
    api.use('steedos:lib');
    api.use('flemay:less-autoprefixer@1.2.0');
    api.use('simple:json-routes@2.1.0');
    api.use('nimble:restivus@0.8.7');
    api.use('aldeed:simple-schema@1.3.3');
    api.use('aldeed:collection2@2.5.0');
    api.use('aldeed:tabular@1.6.0');
    api.use('aldeed:autoform@5.8.0');
    api.use('matb33:collection-hooks@0.8.1');
    api.use('cfs:standard-packages@0.5.9');
    api.use('kadira:blaze-layout@2.3.0');
    api.use('kadira:flow-router@2.10.1');
    api.use('iyyang:cfs-aliyun')
    api.use('cfs:s3');

    api.use('meteorhacks:ssr@2.2.0');
    api.use('meteorhacks:subs-manager');

	api.use('momentjs:moment', 'client');
	api.use('mrt:moment-timezone', 'client');

	api.use('tap:i18n', 'client');
	tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json']
	api.addFiles(tapi18nFiles, 'client');

	api.addFiles('client/libs/mail_manager.js', 'client');

	api.addFiles('client/views/mail.less', 'client');


	api.addFiles('client/views/mail_list.html', 'client');
	api.addFiles('client/views/mail_list.coffee', 'client');

	api.addFiles('client/views/mail_compose.html', 'client');
	api.addFiles('client/views/mail_compose.coffee', 'client');

	api.addFiles('client/views/read_mail.html', 'client');

	api.addFiles('client/views/left.html', 'client');

	api.addFiles('client/views/right.html', 'client');
	api.addFiles('client/views/right.coffee', 'client');
	
	api.addFiles('client/views/mail_home.html', 'client');
	api.addFiles('client/views/mail_home.coffee', 'client');
	api.addFiles('client/router.coffee', 'client');
});

Package.onTest(function(api) {

});
