Package.describe({
	name: 'steedos:fssh',
	version: '0.0.1',
	summary: 'Steedos FSSH',
	git: ''
});

Npm.depends({
  cookies: "0.6.1",
});

Package.onUse(function(api) { 
	api.versionsFrom("1.2.1");

	api.use('coffeescript');
	api.use('check');
	api.use('tracker');
	api.use('session');
	api.use('useraccounts:bootstrap');
	api.use('blaze');
	api.use('templating');
	
	api.use('flemay:less-autoprefixer@1.2.0');
	api.use('simple:json-routes@2.1.0');
	api.use('kadira:blaze-layout@2.3.0');
	api.use('kadira:flow-router@2.10.1');

	api.use('tap:i18n@1.7.0');
	
	api.use('steedos:lib');
	api.use('steedos:admin');
	api.use('steedos:emailjs');
	api.use('steedos:portal');



	//api.add_files("package-tap.i18n", ["client", "server"]);
	tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json']
	api.addFiles(tapi18nFiles, ['client', 'server']);

	api.addFiles('lib/admin_menu.coffee')
	api.addFiles('lib/core.coffee');

	api.addFiles('server/methods/mail_account_save.coffee', 'server');
	api.addFiles('server/methods/auth_user_save.coffee', 'server');
	api.addFiles('server/methods/auth_users_save.coffee', 'server');
	
	api.addFiles('client/views/_helpers.coffee', 'client');
	api.addFiles('client/views/accounts_guide_modal.html', 'client');
	api.addFiles('client/views/accounts_guide_modal.coffee', 'client');
	api.addFiles('client/views/accounts_guide_modal.less', 'client');

	api.addFiles('client/customize.less', 'client');

	api.addFiles('client/subscribe.coffee', 'client');

	// EXPORT
	api.export('FSSH');


	
});

Package.onTest(function(api) {

});
