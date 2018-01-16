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
	api.use('steedos:useraccounts-bootstrap@1.14.2');

	api.use('dburles:collection-helpers');
	api.use('flemay:less-autoprefixer@1.2.0');
	api.use('simple:json-routes');
	api.use('aldeed:simple-schema');
	api.use('aldeed:collection2');
    api.use('aldeed:tabular@1.6.1');
	api.use('aldeed:autoform');
	api.use('matb33:collection-hooks');
	api.use('steedos:cfs-standard-packages');
	api.use('iyyang:cfs-aliyun')
	api.use('steedos:cfs-s3');

	api.use('kadira:flow-router@2.10.1');
	api.use('meteorhacks:subs-manager');
	
	api.use('steedos:base');

	api.use(['webapp'], 'server');

	api.use('momentjs:moment', 'client');

	// TAPi18n
	api.use('templating', 'client');

	api.use('tap:i18n', ['client', 'server']);

	// COMMON
	api.addFiles('desktop_manager.js', 'client');
	api.export('Desktop');

})