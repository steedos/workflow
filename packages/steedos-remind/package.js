Package.describe({
	name: 'steedos:remind',
	version: '0.0.1',
	summary: '',
	git: ''
});

Npm.depends({
	"node-schedule": "1.2.1"
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

	api.use('steedos:base');
	api.use('steedos:workflow');

	api.addFiles('server/ensureIndexes.coffee', 'server');
	api.addFiles('server/schedule/auto_remind_qhd.coffee', 'server');

});

Package.onTest(function(api) {

});