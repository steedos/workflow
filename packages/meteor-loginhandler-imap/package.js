Package.describe({
    name: 'steedos:meteor-loginhandler-imap',
    version: '0.0.1',
    summary: 'Enable login to meteor with email accounts',
    git: 'https://github.com/steedos/apps'
});

Package.onUse(function(api) {
    api.versionsFrom('1.0');

    api.use([
        'coffeescript',
        'webapp'
    ]);

    api.addFiles('cors.coffee', 'server');
});
