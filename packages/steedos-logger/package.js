Package.describe({
	name: 'steedos:logger',
	version: '0.0.2',
	summary: 'Logger for Steedos'
});

Package.onUse(function(api) {
	api.use('coffeescript');
	api.use('underscore');
	api.use('random');
	api.use('logging');
	// api.use('nooitaf:colors@0.0.3');
	api.use('raix:eventemitter');
	api.use('templating', 'client');
	api.use('flemay:less-autoprefixer@1.2.0');
	api.use('kadira:flow-router', 'client');

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
