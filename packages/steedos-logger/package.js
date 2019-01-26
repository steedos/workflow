Package.describe({
	name: 'steedos:logger',
	version: '0.0.2',
	summary: 'Logger for Steedos'
});

Package.onUse(function(api) {
	api.use('coffeescript@1.11.1_4');
	api.use('ecmascript');
	api.use('underscore@1.0.10');
	api.use('random@1.0.10');
	api.use('logging@1.1.15');
	// api.use('nooitaf:colors@0.0.3');
	api.use('raix:eventemitter@0.1.3');
	api.use('templating@1.2.15', 'client');
	api.use('flemay:less-autoprefixer@1.2.0');
	api.use('kadira:flow-router@2.12.1', 'client');
	api.use('tmeasday:check-npm-versions@0.3.2');

	api.addFiles('checkNpm.js', 'server');

	api.addFiles('ansispan.js', 'client');
	api.addFiles('logger.coffee', 'client');
	api.addFiles('client/viewLogs.coffee', 'client');
	api.addFiles('client/views/viewLogs.html', 'client');
	api.addFiles('client/views/viewLogs.less', 'client');
	api.addFiles('client/views/viewLogs.coffee', 'client');
	api.addFiles('client/router.coffee', 'client');

	api.addFiles('server.coffee', 'server');

	api.export('Logger');
});
