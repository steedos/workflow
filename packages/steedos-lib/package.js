Package.describe({
	name: 'steedos:lib',
	version: '0.0.3',
	summary: 'Steedos libraries',
	git: ''
});

Npm.depends({
	"node-schedule": "1.1.1",
	cookies: "0.6.1",
	"weixin-pay": "1.1.7",
	"xml2js": "0.4.17",
	mkdirp: "0.3.5"
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('reactive-var');
	api.use('reactive-dict');
	api.use('coffeescript');
	api.use('random');
	api.use('ddp');
	api.use('check');
	api.use('ddp-rate-limiter@1.0.5');
	api.use('underscore');
	api.use('underscorestring:underscore.string@3.3.4');
	api.use('tracker');
	api.use('session');
	api.use('accounts-base');
	api.use('steedos:useraccounts-bootstrap@1.14.2');

	api.use('dburles:collection-helpers@1.0.4');
	api.use('flemay:less-autoprefixer@1.2.0');
	api.use('simple:json-routes@2.1.0');
	api.use('aldeed:simple-schema@1.5.3');
	api.use('aldeed:collection2@2.10.0');
	api.use('aldeed:tabular@1.6.1');
	api.use('aldeed:autoform@5.8.0');
	api.use('matb33:collection-hooks@0.8.4');
	api.use('cfs:standard-packages@0.5.9');
	api.use('iyyang:cfs-aliyun@0.1.0')
	api.use('cfs:s3@0.1.3');

	api.use('kadira:flow-router@2.10.1');
	api.use('meteorhacks:subs-manager@1.6.4');

	api.use('steedos:base@0.0.17');
	api.use('steedos:version');
	api.use('steedos:autoform@0.0.1');

	api.use(['webapp'], 'server');

	api.use('momentjs:moment@2.14.1', 'client');

	// TAPi18n
	api.use('templating@1.2.15', 'client');

	api.use('tap:i18n@1.8.2', ['client', 'server']);

	// COMMON
	api.addFiles('lib/array_includes.js');
	api.addFiles('lib/core.coffee');
	api.addFiles('lib/settings.coffee', ['client', 'server']);
	api.addFiles('lib/tapi18n.coffee');
	api.addFiles('lib/cfs_fix.coffee', ['client', 'server']);

	api.addFiles('lib/cfs/core.coffee');
	api.addFiles('lib/cfs/avatars.coffee');

	api.addFiles('lib/methods/apps_init.coffee', 'server');
	api.addFiles('lib/methods/utc_offset.coffee');
	api.addFiles('lib/methods/last_logon.coffee');
	api.addFiles('lib/methods/user_add_email.coffee');
	api.addFiles('lib/methods/user_avatar.coffee');


	api.addFiles('lib/methods/email_templates_reset.js');
	api.addFiles('lib/methods/upgrade_data.js', 'server');

	api.addFiles('lib/steedos/push.coffee');


	api.addFiles('client/core.coffee', 'client');
	api.addFiles('client/momentjs/zh-cn.js', 'client');
	api.addFiles('client/language.coffee', 'client');

	api.addFiles('client/steedos/router.coffee', 'client');
	api.addFiles('client/steedos/tap-i18n-fix.js', 'client');
	api.addFiles('client/steedos/subscribe.coffee', 'client');

	api.addFiles('client/steedos/css/adminlte.less', 'client');

	api.addFiles('client/steedos/views/animated.less', 'client');
	api.addFiles('client/steedos/views/404.less', 'client');
	api.addFiles('client/steedos/views/404.html', 'client');

	// api.addFiles('client/steedos/views/admin/admin_dashboard.html', 'client');
	// api.addFiles('client/steedos/views/admin/admin_dashboard.coffee', 'client');

	api.addFiles('client/steedos/views/layouts/main.html', 'client');

	api.addFiles('client/steedos/views/layouts/header_logo.html', 'client');
	api.addFiles('client/steedos/views/layouts/header_logo.coffee', 'client');

	api.addFiles('client/steedos/views/layouts/header_workflow_badge.html', 'client');
	api.addFiles('client/steedos/views/layouts/header_workflow_badge.coffee', 'client');

	api.addFiles('client/steedos/views/layouts/header_cms_badge.html', 'client');
	api.addFiles('client/steedos/views/layouts/header_cms_badge.coffee', 'client');

	api.addFiles('client/steedos/views/layouts/header_account.html', 'client');
	api.addFiles('client/steedos/views/layouts/header_account.coffee', 'client');

	api.addFiles('client/steedos/views/layouts/header.html', 'client');
	api.addFiles('client/steedos/views/layouts/header.coffee', 'client');
	api.addFiles('client/steedos/views/layouts/header.less', 'client');

	api.addFiles('client/steedos/views/layouts/sidebar.html', 'client');
	api.addFiles('client/steedos/views/layouts/sidebar.coffee', 'client');

	api.addFiles('client/steedos/views/login/login_layout.less', 'client');
	api.addFiles('client/steedos/views/login/login_layout.html', 'client');
	api.addFiles('client/steedos/views/login/login_layout.coffee', 'client');

	api.addFiles('client/steedos/views/profile/linked.html', 'client');
	api.addFiles('client/steedos/views/profile/linked.coffee', 'client');

	api.addFiles('client/steedos/views/profile/profile.less', 'client');
	api.addFiles('client/steedos/views/profile/profile.html', 'client');
	api.addFiles('client/steedos/views/profile/profile.coffee', 'client');

	api.addFiles('client/steedos/views/space/space_info.html', 'client');
	api.addFiles('client/steedos/views/space/space_info.coffee', 'client');

	api.addFiles('client/steedos/views/space/space_select.html', 'client');
	api.addFiles('client/steedos/views/space/space_select.coffee', 'client');

	api.addFiles('client/steedos/views/about/steedos_about.html', 'client');
	api.addFiles('client/steedos/views/about/steedos_about.coffee', 'client');
	api.addFiles('client/steedos/views/about/steedos_about.css', 'client');

	api.addFiles('client/steedos/views/billing/steedos_billing.html', 'client');
	api.addFiles('client/steedos/views/billing/steedos_billing.coffee', 'client');
	api.addFiles('client/steedos/views/billing/steedos_billing.less', 'client');
	api.addFiles('client/steedos/views/billing/space_recharge_modal.html', 'client');
	api.addFiles('client/steedos/views/billing/space_recharge_modal.coffee', 'client');
	api.addFiles('client/steedos/views/billing/space_recharge_qrcode_modal.html', 'client');
	api.addFiles('client/steedos/views/billing/space_recharge_qrcode_modal.coffee', 'client');

	api.addFiles('client/tooltip.coffee', 'client');

	api.addFiles('server/steedos/startup/migrations/v1.coffee', 'server');
	api.addFiles('server/steedos/startup/migrations/v2.coffee', 'server');
	api.addFiles('server/steedos/startup/migrations/v3.coffee', 'server');
	api.addFiles('server/steedos/startup/migrations/v4.coffee', 'server');
	api.addFiles('server/steedos/startup/migrations/v5.coffee', 'server');
	api.addFiles('server/steedos/startup/migrations/v6.coffee', 'server');
	api.addFiles('server/steedos/startup/migrations/xrun.coffee', 'server');

	// methods
	api.addFiles('server/methods/setKeyValue.js', 'server');
	api.addFiles('server/methods/billing_settleup.coffee', 'server');
	api.addFiles('server/methods/setUsername.coffee', 'server');
	api.addFiles('server/methods/billing_recharge.coffee', 'server');
	api.addFiles('server/methods/get_space_user_count.coffee', 'server');
	api.addFiles('server/methods/user_secret.coffee', 'server');

	api.addFiles('server/publications/space_user_signs.coffee', 'server');
	api.addFiles('server/publications/user_inbox_instance.coffee', 'server');
	api.addFiles('server/publications/modules.coffee', 'server');
	api.addFiles('server/publications/weixin_pay_code_url.coffee', 'server');

	// managers
	api.addFiles('server/lib/billing_manager.coffee', 'server');

	//api
	api.addFiles('route/api_get_apps.coffee', 'server');


	// schedule
	api.addFiles('server/schedule/statistics.js', 'server');
	api.addFiles('server/schedule/billing.coffee', 'server');

	api.addFiles('lib/admin.coffee');

	api.addFiles('steedos.info', ['client', 'server']);

	// functions
	api.addFiles('server/functions/checkUsernameAvailability.coffee', 'server');

	// routes
	api.addFiles('server/routes/api_billing_recharge_notify.coffee', 'server');

	// EXPORT
	api.export('Steedos');
	api.export('db');
	api.export('SteedosOffice');

	api.export(['billingManager'], ['server']);
});

Package.onTest(function(api) {

});