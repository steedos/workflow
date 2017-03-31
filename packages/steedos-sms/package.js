Package.describe({
	name: 'steedos:smsqueue',
	version: '0.0.1',
	summary: '',
	git: ''
});

Npm.depends({
	"aliyun-sms-node": "1.1.2"
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use([
		'raix:eventstate@0.0.2',
		'check',
		'mongo',
		'underscore',
		'ejson',
		'random'
	]);

	api.use('mongo', 'server');

	// Common api
	api.addFiles([
		'lib/common/main.js',
	], ['server']);

	// Common api
	api.addFiles([
		'lib/common/sms.js'
	], ['server']);

	// API's
	api.addFiles('lib/server/api.js', 'server');


	api.export('SMSQueue', ['server']);

});

Package.onTest(function(api) {

});