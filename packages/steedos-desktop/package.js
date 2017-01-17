Package.describe({
	name: 'steedos:desktop',
	version: '0.0.1',
	summary: 'Steedos libraries',
	git: ''
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
	api.use('underscorestring:underscore.string');
	api.use('tracker');
	api.use('session');
	api.use('accounts-base');
	api.use('useraccounts:bootstrap');

	api.use('dburles:collection-helpers');
	api.use('flemay:less-autoprefixer@1.2.0');
	api.use('simple:json-routes');
	api.use('aldeed:simple-schema');
	api.use('aldeed:collection2');
	api.use('aldeed:tabular@2.1.1');
	api.use('aldeed:autoform');
	api.use('matb33:collection-hooks');
	api.use('cfs:standard-packages@0.5.9');
	api.use('iyyang:cfs-aliyun')
	api.use('cfs:s3');

	api.use('kadira:flow-router@2.10.1');
	api.use('meteorhacks:subs-manager');
	
	api.use('steedos:lib');

	api.use(['webapp'], 'server');

	api.use('momentjs:moment', 'client');

	// TAPi18n
	api.use('templating', 'client');

	api.use('tap:i18n', ['client', 'server']);
	// //api.add_files("package-tap.i18n", ["client", "server"]);
	// tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json'];
	// api.addFiles(tapi18nFiles, ['client', 'server']);

	// COMMON
	api.addFiles('desktop_manager.js', 'client');

})