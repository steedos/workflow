Package.describe({
	name: 'steedos:heapdump',
	version: '0.0.1',
	summary: 'Steedos heapdump',
	git: ''
});

Npm.depends({
	heapdump: "0.3.9"
});

Package.onUse(function (api) {
	api.versionsFrom("1.2.1");

	api.use('coffeescript');
	api.use('check');

	api.addFiles('server/dump.coffee', 'server');

});

Package.onTest(function (api) {

});