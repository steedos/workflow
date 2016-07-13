Package.describe({
    name: 'steedos:webkit-notification',
    version: '0.0.1',
    summary: 'Steedos Webkit Notification',
    git: ''
});

Package.onUse(function(api) { 
    api.versionsFrom('1.0');

    api.use('coffeescript');
    api.use('raix:push');
    api.use('mongo');

    api.addFiles('server/models/raix_push_notifications.coffee','server');

    api.addFiles('lib/jquery.notification.js', 'client');
    api.addFiles('client/observe_notifications.coffee', 'client');

    // EXPORT
    api.export('Steedos');
    api.export('db');
});

Package.onTest(function(api) {

});