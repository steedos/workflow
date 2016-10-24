Package.describe({
	name: 'steedos:contacts',
	version: '0.0.1',
	summary: 'Steedos Contacts App',
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
	api.use('tracker');
	api.use('session');
    api.use('blaze');
    api.use('templating');
    api.use('steedos:lib');
    api.use('steedos:api');
    api.use('steedos:ui');
    api.use('flemay:less-autoprefixer@1.2.0');
    api.use('simple:json-routes@2.1.0');
    api.use('nimble:restivus@0.8.7');
    api.use('aldeed:simple-schema@1.3.3');
    api.use('aldeed:collection2@2.5.0');
    api.use('aldeed:tabular@1.6.0');
    api.use('aldeed:autoform@5.8.0');
    api.use('matb33:collection-hooks@0.8.1');
    api.use('cfs:standard-packages@0.5.9');
    api.use('kadira:blaze-layout@2.3.0');
    api.use('kadira:flow-router@2.10.1');
    api.use('iyyang:cfs-aliyun')
    api.use('cfs:s3');

    api.use('meteorhacks:ssr@2.2.0');
    api.use('meteorhacks:subs-manager');
    api.use('tap:i18n@1.7.0');
	api.use('momentjs:moment', 'client');
	api.use('mrt:moment-timezone', 'client');


	api.use('tap:i18n', ['client', 'server']);
	tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json']
	api.addFiles(tapi18nFiles, ['client', 'server']);
	
	api.addFiles('lib/core.coffee', ['client', 'server']);
	api.addFiles('lib/models/contact_cards.coffee', ['client', 'server']);
	api.addFiles('lib/models/address_groups.coffee', ['client', 'server']);
	api.addFiles('lib/models/address_books.coffee', ['client', 'server']);
	api.addFiles('lib/admin.coffee', ['client', 'server']);

	api.addFiles('server/publications/contact_cards.coffee', 'server');
	api.addFiles('server/publications/address_groups.coffee', 'server');
	api.addFiles('server/publications/address_books.coffee', 'server');

	api.addFiles('client/layout/master.html', 'client');
    api.addFiles('client/layout/master.coffee', 'client');
    api.addFiles('client/layout/master.less', 'client');
    api.addFiles('client/layout/sidebar.html', 'client');
    api.addFiles('client/layout/sidebar.coffee', 'client');
    api.addFiles('client/layout/sidebar.less', 'client');

	api.addFiles('client/libs/contacts_manager.js', 'client');

	api.addFiles('client/router.coffee', 'client');
	api.addFiles('client/subscribe.coffee', 'client');

	api.addFiles('client/views/contact.less', 'client');
	
	api.addFiles('client/views/main.html', 'client');
	api.addFiles('client/views/main.coffee', 'client');
	api.addFiles('client/views/tree.html', 'client');
	api.addFiles('client/views/tree.coffee', 'client');
	
	api.addFiles('client/views/selectedValue.html', 'client');

	api.addFiles('client/views/contact_list.html', 'client');
	api.addFiles('client/views/contact_list.coffee', 'client');

	api.addFiles('tabular.coffee');
	api.addFiles('tabular_books.coffee');
	
	api.export('ContactsManager');
});

Package.onTest(function(api) {

});
