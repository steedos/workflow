Package.describe({
	name: 'steedos:chat',
	version: '0.0.1',
	summary: 'Steedos Chat',
	git: ''
});


Package.onUse(function(api) { 
    api.versionsFrom("1.2.1");

    //TODO 需要确认用到了那些包
    api.use('reactive-var');
    api.use('reactive-dict');
    api.use('coffeescript');
    api.use('random');
    api.use('underscore');
    api.use('tracker');
    api.use('session');
    api.use('blaze');
    api.use('templating');
    api.use('webapp', 'server');
    
    api.use('flemay:less-autoprefixer@1.2.0');
    api.use('simple:json-routes@2.1.0');
    api.use('nimble:restivus@0.8.7');
    api.use('aldeed:simple-schema@1.3.3');
    api.use('aldeed:collection2@2.5.0');
    api.use('aldeed:tabular@1.6.1');
    api.use('aldeed:autoform@5.8.0');
    api.use('matb33:collection-hooks@0.8.1');
    api.use('steedos:cfs-standard-packages');
    api.use('kadira:blaze-layout@2.3.0');
    api.use('kadira:flow-router@2.10.1');

    api.use('meteorhacks:ssr@2.2.0');
    api.use('steedos:base');
    api.use('tap:i18n@1.7.0');
    api.use('meteorhacks:subs-manager');


    api.addFiles('lib/modals/room.coffee');
    api.addFiles('lib/modals/subscription.coffee');

    api.addFiles('server/methods/username_init.coffee', 'server');
    api.addFiles('server/publications/subscription.coffee', 'server');

	api.addFiles('client/subcribe.coffee', 'client');  
});

Package.onTest(function(api) {

});