Package.describe({
	name: 'steedos:workflow-base',
	version: '0.0.1',
	summary: 'Steedos workflow-base libraries',
	git: ''
});

Npm.depends({
	cookies: "0.6.1"
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
	api.use('simple:json-routes@2.1.0');
	api.use('nimble:restivus@0.8.7');
	api.use('aldeed:simple-schema@1.3.3');
	api.use('aldeed:collection2@2.5.0');
	api.use('kadira:flow-router@2.10.1');


	api.addFiles('client/admin_import_flow_modal.html', 'client');
	api.addFiles('client/admin_import_flow_modal.coffee', 'client');

	api.addFiles('server/lib/export.coffee', 'server');
	api.addFiles('routes/export.coffee', 'server');
	api.addFiles('server/lib/import.coffee', 'server');
	api.addFiles('routes/import.coffee', 'server');

	api.export(['steedosExport', 'steedosImport'], ['server']);

});

Package.onTest(function(api) {

});