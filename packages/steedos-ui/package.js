Package.describe({
	name: 'steedos:ui',
	version: '0.0.1',
	summary: 'Steedos ui',
	git: 'https://github.com/steedos/apps/tree/master/packages/steedos-ui',
	documentation: null
});

Package.onUse(function(api) { 
	api.versionsFrom('1.0');

	api.use(['flemay:less-autoprefixer@1.2.0']);

	api.use([
		'mongo',
		'session',
		'jquery',
		'tracker',
		'reactive-var',
		'ecmascript@0.6.3',
		'templating',
		'coffeescript',
		'underscore'
	]);

	api.addFiles('lib/Modernizr.js', 'client');

	api.addFiles('lib/steedos.coffee', 'client');
	api.addFiles('lib/fireGlobalEvent.coffee', 'client');
	api.addFiles('lib/helpers.coffee', 'client');
	api.addFiles('lib/navigation_controller.coffee', 'client');

	api.addFiles('utils/_lesshat.import.less', 'client');
	api.addFiles('utils/_keyframes.import.less', 'client');
});

Package.onTest(function(api) {

});
