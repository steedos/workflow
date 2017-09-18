Package.describe({
	name: 'steedos:records',
	version: '0.0.1',
	summary: 'Steedos records system',
	git: ''
});


Npm.depends({
    'request':'2.40.0',
    mkdirp: "0.3.5"
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

    api.use('ecmascript');
    
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
    api.use('flemay:less-autoprefixer@1.2.0');
    api.use('simple:json-routes@2.1.0');
    api.use('nimble:restivus@0.8.7');
    api.use('aldeed:simple-schema@1.3.3');
    api.use('aldeed:collection2@2.5.0');
    api.use('aldeed:tabular@1.6.1');
    api.use('aldeed:autoform@5.8.0');
    api.use('matb33:collection-hooks@0.8.1');
    api.use('cfs:standard-packages@0.5.9');
    api.use('kadira:blaze-layout@2.3.0');
    api.use('kadira:flow-router@2.10.1');
    api.use('iyyang:cfs-aliyun')
    api.use('cfs:s3');

    api.use('meteorhacks:ssr@2.2.0');
    api.use('tap:i18n@1.7.0');
    api.use('meteorhacks:subs-manager');

    api.use(['webapp'], 'server');

    api.use('momentjs:moment', 'client');
    api.use('mrt:moment-timezone', 'client');

	api.use('steedos:adminlte');
    api.use('steedos:base');
    // api.use('steedos:theme');
    
    api.use('steedos:workflow');
    api.use('simple:json-routes@2.1.0');
    api.use('steedos:records-i18n');
    api.use('http');

    api.addFiles('client/layout/layout.html', 'client');
    api.addFiles('client/layout/layout.less', 'client');

    api.addFiles('client/search/records_repository.html', 'client');
    api.addFiles('client/search/records_repository.coffee', 'client');
    api.addFiles('client/search/records_repository.less', 'client');

    api.addFiles('client/core.coffee', 'client');
    api.addFiles('client/router.coffee', 'client');

    api.addFiles('server/api/search/search_api.coffee','server');

});

