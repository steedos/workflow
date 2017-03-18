Package.describe({
    name: 'loaders-css',
    version: '0.1.2',
    summary: 'loaders style',
    git: ''
});

Npm.depends({
  cookies: "0.6.1",
});

Package.onUse(function(api) { 
    api.versionsFrom("1.2.1");

    api.addFiles('loaders.css', 'client');
});

Package.onTest(function(api) {

});
