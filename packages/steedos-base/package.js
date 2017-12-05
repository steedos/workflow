Package.describe({
	name: 'steedos:base',
	version: '0.0.62',
	summary: 'Steedos libraries',
	git: 'https://github.com/steedos/apps/tree/master/packages/steedos-base'
});

Npm.depends({
	cookies: "0.6.1"
});

Package.onUse(function(api) {
	api.versionsFrom('METEOR@1.3');

	api.use('session');
	api.use('coffeescript');
	api.use('ecmascript');
	api.use('blaze-html-templates');
	api.use('underscore');
	api.use('reactive-var');
	api.use('tracker');

	api.use('accounts-base');

	api.use('matb33:collection-hooks@0.8.4');
	api.use('flemay:less-autoprefixer@1.2.0');
	api.use('kadira:flow-router@2.10.1');
	api.use('kadira:blaze-layout@2.3.0');
	api.use('meteorhacks:subs-manager@1.6.4');
	api.use('dburles:collection-helpers@1.0.4');
	api.use('peppelg:bootstrap-3-modal@1.0.4');

	api.use('momentjs:moment@2.14.1');

	api.use('tap:i18n@1.8.2');
	api.use('aldeed:simple-schema@1.5.3');
	api.use('aldeed:tabular@1.6.1');
	api.use('momentjs:moment');
	api.use('simple:json-routes@2.1.0');

	api.use('steedos:ionicons@0.1.7');
	api.use('steedos:i18n@0.0.10');
	api.use('steedos:ui@0.0.1');
	api.use('steedos:theme@0.0.29');

	api.addFiles('lib/steedos_util.js', ['client', 'server']);

	api.addFiles([
		'lib/core.coffee',
		'lib/tap-i18n.coffee'
	]);

	api.addFiles('lib/simple_schema_extend.js');

	api.addFiles('lib/models/apps.coffee');
	api.addFiles('lib/models/users.coffee');
	api.addFiles('lib/models/spaces.coffee');
	api.addFiles('lib/models/space_users.coffee');
	api.addFiles('lib/models/organizations.coffee');
	api.addFiles('lib/models/users_changelogs.coffee');
	api.addFiles('lib/models/steedos_keyvalue.coffee');
	api.addFiles('lib/models/steedos_statistics.coffee');
	api.addFiles('lib/models/space_user_signs.coffee');
	api.addFiles('lib/models/audit_logs.coffee');
	api.addFiles('lib/models/billings.coffee');
	api.addFiles('lib/models/modules.coffee');
	api.addFiles('lib/models/modules_changelogs.coffee');
	api.addFiles('lib/models/billing_pay_records.coffee');
	api.addFiles('lib/models/space_settings.coffee');

	api.addFiles('routes/collection.coffee', 'server');
	api.addFiles('routes/sso.coffee', 'server');

	api.addFiles('lib/ajax_collection.coffee', 'client');

	api.addFiles('lib/steedos_data_manager.js', 'client');

	api.addFiles('routes/avatar.coffee', 'server');
	api.addFiles('routes/access_token.coffee', 'server');

	api.addFiles('server/publications/apps.coffee', 'server');
	api.addFiles('server/publications/my_spaces.coffee', 'server');
	api.addFiles('server/methods/my_contacts_limit.coffee', 'server');

	api.addFiles('client/lib/printThis/printThis.js', 'client');

	api.addFiles([
		'client/base.less',
		'client/core.coffee',
		'client/swipe.coffee',
		'client/swipe.less',
		'client/api.coffee',
		'client/helpers.coffee',
		'client/router.coffee',
		'client/layout/main.html',
		'client/layout/main.less',
		'client/layout/main.coffee',
		'client/layout/layout.html',
		'client/layout/layout.less',
		'client/layout/header_logo.html',
		'client/layout/header_logo.coffee',
		'client/layout/header_space.html',
		'client/layout/header_space.coffee',
		'client/layout/header_refresh.html',
		'client/layout/header_refresh.coffee',
		'client/layout/header_loading.html',
		'client/layout/header.html',
		'client/layout/header.coffee',
		'client/layout/header.less',
		'client/layout/content_wrapper_shadow.html',
		'client/layout/sidebar.html',
		'client/layout/steedosheader-account.html',
		'client/layout/steedosheader-account.coffee',
		'client/layout/steedosheader-account.less',
		'client/views/app_list_box_modal.html',
		'client/views/app_list_box_modal.coffee',
		'client/views/app_list_box_modal.less',
		'client/views/space_switcher.html',
		'client/views/space_switcher.coffee',
		'client/views/space_switcher.less',
		'client/subscribe.coffee',
		'client/views/loading.html',
		'client/views/loading.coffee',
		'client/views/loading.less',
		'client/views/space_switcher_modal.html',
		'client/views/space_switcher_modal.coffee',
		'client/views/sidebar_user_panel.html',
		'client/views/sidebar_user_panel.coffee',
		'client/views/sidebar_user_panel.less',
		'client/dataTables_bootstrap.less',
		'client/my_contacts_limit.coffee'
	], "client");


	api.addFiles('client/lib/jquery-touch-events/jquery.mobile-events.js', 'client');

	api.addFiles('client/layout/login_layout.html', "client");
	api.addFiles('client/layout/login_layout.coffee', "client");
	api.addFiles('client/layout/login_layout.less', "client");
	api.addFiles('client/layout/tabbar.html', "client");
	api.addFiles('client/layout/tabbar.coffee', "client");
	api.addFiles('client/layout/tabbar.less', "client");
	api.addFiles('client/views/springboard.less', 'client');
	api.addFiles('client/views/springboard.html', 'client');
	api.addFiles('client/views/springboard.coffee', 'client');
	api.addAssets('client/images/default-avatar.png', 'client');
	api.addFiles('client/views/workbench.less', 'client');
	api.addFiles('client/views/workbench.html', 'client');
	api.addFiles('client/views/workbench.coffee', 'client');
	api.addFiles('client/views/manage_business.less', 'client');
	api.addFiles('client/views/manage_business.html', 'client');
	api.addFiles('client/views/manage_business.coffee', 'client');

	api.addFiles('client/layout/top_sidebar.html', 'client');
	api.addFiles('client/layout/top_sidebar.coffee', 'client');
	api.addFiles('client/layout/top_sidebar.less', 'client');

	api.addFiles('client/iframe/master.html', 'client');
	api.addFiles('client/iframe/master.coffee', 'client');
	api.addFiles('client/iframe/master.less', 'client');

	api.addFiles('client/loading.coffee', 'client');

	api.addFiles('client/layout/master.less', 'client');
	api.addFiles('client/layout/master.html', 'client');
	api.addFiles('client/layout/master.coffee', 'client');

	api.addFiles('client/layout/notFound_layout.html', 'client');
	api.addFiles('client/layout/notFound_layout.coffee', 'client');
	api.addFiles('client/layout/notFound_layout.less', 'client');

	api.addFiles('client/autoupdate_cordova.coffee', 'web.cordova');

	api.export('Steedos');
	api.export('db');

	api.export('AjaxCollection');
	api.export("SteedosDataManager");
});

Package.onTest(function(api) {

});