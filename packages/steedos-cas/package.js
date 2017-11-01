Package.describe({
	name: 'steedos:cas',
	version: '0.0.1',
	summary: 'Steedos CAS System',
	git: ''
});

Npm.depends({
	'cookies': "0.6.1",
	'xml2js':"0.4.19"
});

Package.onUse(function (api) {
	api.versionsFrom('METEOR@1.3');

	api.use('session');
	api.use('coffeescript');
	api.use('ecmascript');


	api.addFiles('server/validateTicket.coffee','server');

});

Package.onTest(function (api) {

});