Package.describe({
	name: 'steedos:lib',
	version: '0.0.1',
	summary: 'Steedos libraries',
	git: ''
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
	api.use('underscorestring:underscore.string');
	api.use('tracker');
	api.use('session');
	api.use('accounts-base');
	
  	api.use('simple:json-routes');
	api.use('aldeed:simple-schema');
	api.use('aldeed:collection2');
	api.use('aldeed:tabular');
	api.use('aldeed:autoform');
	api.use('matb33:collection-hooks');


	api.use(['webapp'], 'server');

	api.use('momentjs:moment', 'client');

	// TAPi18n
	api.use('templating', 'client');

	api.use('tap:i18n', ['client', 'server']);
	//api.add_files("package-tap.i18n", ["client", "server"]);
	tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json']
	api.addFiles(tapi18nFiles, ['client', 'server']);
	
	// COMMON
	api.addFiles('lib/collection_helpers.js');
	api.addFiles('lib/array_includes.js');
	api.addFiles('lib/core.coffee');
	api.addFiles('lib/settings.coffee', ['client', 'server']);
	api.addFiles('lib/tapi18n.coffee');

	api.addFiles('lib/models/users.coffee');
	api.addFiles('lib/models/spaces.coffee');
	api.addFiles('lib/models/space_users.coffee');
	api.addFiles('lib/models/organizations.coffee');
	api.addFiles('lib/models/users_changelogs.coffee');
	api.addFiles('lib/models/apps.coffee');
	api.addFiles('lib/models/steedos_keyvalue.coffee');

	api.addFiles('lib/methods/apps_init.coffee', 'server');
	api.addFiles('lib/methods/utc_offset.coffee');
	api.addFiles('lib/methods/last_logon.coffee');
	api.addFiles('lib/methods/user_add_email.coffee');
	api.addFiles('lib/methods/user_avatar.coffee');

	api.addFiles('lib/publications/apps.coffee');

	api.addFiles('client/helpers.coffee', 'client');
	api.addFiles('client/language.coffee', 'client');

	api.addFiles('lib/methods/emial_templates_reset.js');
	// EXPORT
	api.export('Steedos');
	api.export('db');
});

Package.onTest(function(api) {

});
