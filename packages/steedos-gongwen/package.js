Package.describe({
    name: 'steedos:gongwen',
    version: '0.0.1',
    summary: 'Steedos workflow libraries',
    git: ''
});

Package.onUse(function(api) { 
    api.versionsFrom('1.0');

    api.use('tap:i18n@1.7.0');

    api.use('tap:i18n', ['client', 'server']);
    tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json']
    api.addFiles(tapi18nFiles, ['client', 'server']);

    // EXPORT
    
});

Package.onTest(function(api) {

});
