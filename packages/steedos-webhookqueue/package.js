Package.describe({
	name: 'steedos:webhookqueue',
	version: '0.0.1',
	summary: '',
	git: ''
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
		'lib/common/webhooks.js'
	], ['server']);

	// API's
	api.addFiles('lib/server/api.js', 'server');


	api.export('WebhookQueue', ['server']);

});

Package.onTest(function(api) {

});