Package.describe({
    name: 'steedos:theme',
    version: '0.0.1',
    summary: 'Steedos theme for default',
    git: ''
});

Package.onUse(function(api) { 
    api.versionsFrom('1.0');

    api.use('flemay:less-autoprefixer@1.2.0');
    api.use('tap:i18n@1.7.0');

    api.use('tap:i18n', ['client', 'server']);
    tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json']
    api.addFiles(tapi18nFiles, ['client', 'server']);

    api.addAssets("client/background/beach.jpg", "client");
    api.addAssets("client/background/books.jpg", "client");
    api.addAssets("client/background/birds.jpg", "client");
    api.addAssets("client/background/cloud.jpg", "client");
    api.addAssets("client/background/sea.jpg", "client");
    api.addAssets("client/background/flower.jpg", "client");
    api.addAssets("client/background/fish.jpg", "client");

    api.addFiles("client/background.less", "client");

    // EXPORT
    
});

Package.onTest(function(api) {

});
