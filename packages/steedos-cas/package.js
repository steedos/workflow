Package.describe({
	name: 'steedos:cas',
	version: '0.0.1',
	summary: 'Steedos CAS System',
	git: ''
});

Package.onUse(function (api) {
	api.use('ecmascript');
	api.versionsFrom('METEOR@1.3');
	
	api.use('session');
	api.use('coffeescript');
	api.use('ecmascript');
	
	api.addFiles('checkNpm.js', 'server');

	api.addFiles('server/validateTicket.coffee','server');

});

Package.onTest(function (api) {

});