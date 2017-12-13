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
    api.use('tracker');
    api.use('meteorhacks:subs-manager');

    api.use('steedos:base');

    api.addFiles('server/models/raix_push_notifications.coffee');

    api.addFiles('server/methods/calculate_box.coffee');

    api.addFiles('lib/jquery.notification.js', 'client');
    api.addFiles('client/observe_notifications.coffee', 'client');
});

Package.onTest(function(api) {

});