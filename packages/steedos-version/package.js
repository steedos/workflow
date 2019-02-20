Package.describe({
	name: 'steedos:version',
	version: '1.0.5',
	summary: 'steedos version',
	git: ''
});

Package.registerBuildPlugin({
	name: 'compileVersion',
	use: ['coffeescript@1.11.1_4','ecmascript'],
	sources: ['plugin/compile-version.coffee']
});

Package.onUse(function(api) {
	api.use('isobuild:compiler-plugin@1.0.0');
});
