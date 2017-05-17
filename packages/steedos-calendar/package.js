Package.describe({
	name: 'steedos:calendar',
	version: '0.0.1',
	summary: 'Steedos calendar system',
	git: ''
});

Npm.depends({
  'icalendar':'0.7.1',
  'MD5':'1.3.0',
  'moment-timezone':'0.5.13',
  'uuid':'3.0.1'
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
    api.use('kadira:blaze-layout@2.3.0');
    api.use('kadira:flow-router@2.10.1');

    api.use('aldeed:autoform-bs-datetimepicker');

    api.use('meteorhacks:ssr@2.2.0');
    api.use('tap:i18n@1.7.0');
    api.use('meteorhacks:subs-manager');

    api.use(['webapp'], 'server');

    api.use('momentjs:moment', 'client');
    api.use('mrt:moment-timezone', 'client');

    api.use('steedos:adminlte');
    api.use('steedos:base');
    api.use('steedos:theme@0.0.11');
    api.use('simple:json-routes@2.1.0');

    api.use('rzymek:fullcalendar@3.4.0');

    api.addFiles('client/event/event.html', 'client');
    api.addFiles('client/event/event.coffee', 'client');
    api.addFiles('client/event/event.less', 'client');

    api.addFiles('client/layout/layout.html', 'client');
    api.addFiles('client/layout/layout.less', 'client');
    api.addFiles('client/layout/sidebar.html', 'client');
    api.addFiles('client/layout/sidebar.coffee', 'client');
    api.addFiles('client/layout/sidebar.less', 'client');

    api.addFiles('client/core.coffee', 'client');
    api.addFiles('client/local.coffee', 'client');
    api.addFiles('client/router.coffee', 'client');
    api.addFiles('client/subscribe.coffee', 'client');

    api.addFiles('models/calendarchanges.coffee');
    api.addFiles('models/calendarinstances.coffee');
    api.addFiles('models/calendars.coffee');
    api.addFiles('models/events.coffee');

    api.addFiles('server/methods/calendarInit.coffee','server');
    api.addFiles('server/methods/selectGetUsers.coffee','server');

    api.addFiles('server/publications/calendars.coffee','server');
    api.addFiles('server/publications/events.coffee','server');
    
    api.addFiles('server/main.coffee','server');

});

