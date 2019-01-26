Package.describe({
	name: 'steedos:heapdump',
	version: '0.0.1',
	summary: 'Steedos heapdump',
	git: ''
});

Package.onUse(function (api) {
	api.use('ecmascript');
	api.versionsFrom("1.2.1");

	api.use('coffeescript');
	api.use('check');

	api.addFiles('checkNpm.js', 'server');

	api.addFiles('server/dump.coffee', 'server');

});

Package.onTest(function (api) {

});