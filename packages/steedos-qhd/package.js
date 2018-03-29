Package.describe({
    name: 'steedos:qhd',
    version: '0.0.1',
    summary: 'Steedos for qhd',
    git: ''
});

Package.onUse(function(api) {
    api.versionsFrom('1.0');
    api.use('coffeescript');
    api.use('blaze');
    api.use('templating');

    api.use('flemay:less-autoprefixer@1.2.0');
    api.use('simple:json-routes@2.1.0');
    api.use('kadira:blaze-layout@2.3.0');
    api.use('kadira:flow-router@2.10.1');

    api.use('tap:i18n@1.7.0');
    api.use('tap:i18n', ['client', 'server']);

    api.use('steedos:workflow');

    tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json']
    api.addFiles(tapi18nFiles, ['client', 'server']);

    api.addFiles("server/routes/notify_wenshu.coffee", "server");
    api.addFiles("server/routes/notify_cc_steps.coffee", "server");
    api.addFiles("server/routes/notification_wenshu.coffee", "server");


    // EXPORT

});

Package.onTest(function(api) {

});