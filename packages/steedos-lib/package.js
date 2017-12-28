Package.describe({
	name: 'steedos:lib',
	version: '0.0.3',
	summary: 'Steedos libraries',
	git: ''
});

Npm.depends({
	"node-schedule": "1.1.1",
	cookies: "0.6.1",
	"weixin-pay": "1.1.7",
	"xml2js": "0.4.17",
	mkdirp: "0.3.5"
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('reactive-var');
	api.use('reactive-dict');
	api.use('coffeescript');
	api.use('random');
	api.use('ddp');
	api.use('check');
	api.use('ddp-rate-limiter@1.0.5');
	api.use('underscore');
	api.use('underscorestring:underscore.string@3.3.4');
	api.use('tracker');
	api.use('session');
	api.use('accounts-base');
	api.use('steedos:useraccounts-bootstrap@1.14.2');

	api.use('dburles:collection-helpers@1.0.4');
	api.use('flemay:less-autoprefixer@1.2.0');
	api.use('simple:json-routes@2.1.0');
	api.use('aldeed:simple-schema@1.5.3');
	api.use('aldeed:collection2@2.10.0');
	api.use('aldeed:tabular@1.6.1');
	api.use('aldeed:autoform@5.8.0');
	api.use('matb33:collection-hooks@0.8.4');
	api.use('cfs:standard-packages@0.5.9');
	api.use('iyyang:cfs-aliyun@0.1.0')
	api.use('cfs:s3@0.1.3');

	api.use('kadira:flow-router@2.10.1');
	api.use('meteorhacks:subs-manager@1.6.4');

	api.use('steedos:base@0.0.17');
	api.use('steedos:version');
	api.use('steedos:autoform@0.0.1');

	api.use(['webapp'], 'server');

	api.use('momentjs:moment@2.14.1', 'client');

	// TAPi18n
	api.use('templating@1.2.15', 'client');

	api.use('tap:i18n@1.8.2', ['client', 'server']);

	// EXPORT
	api.export('Steedos');
	api.export('db');
	api.export('SteedosOffice');

	api.export(['billingManager'], ['server']);
});

Package.onTest(function(api) {

});