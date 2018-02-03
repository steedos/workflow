Package.describe({
	name: 'steedos:i18n-iso-countries',
	summary: 'Small lib that contains various information of a country',
	version: '3.3.0',
	git: 'https://github.com/geneh/e164-phones-countries.git'
});

Package.onUse(function(api) {
	api.versionsFrom('METEOR@1.3');
	api.use('ecmascript');
	
	api.addFiles([
		'index.js',
		'entry-node.js'
	]);
	api.export('IsoCountries');
});

Package.onTest(function(api) {

});