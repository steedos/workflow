Package.describe({
    name: 'steedos:loaders-css',
    version: '0.1.3',
    summary: 'loaders style',
    git: 'https://github.com/steedos/apps/tree/master/packages/loaders-css',
    documentation: null
});


Package.onUse(function(api) {
    api.versionsFrom("1.2.1");

    api.addFiles('loaders.css', 'client');
});

Package.onTest(function(api) {

});
