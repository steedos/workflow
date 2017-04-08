Package.describe({
  name: 'steedos:adminlte',
  version: '2.3.12',
  summary: 'AdminLTE dashboard theme',
  git: 'https://github.com/steedos/meteor-admin-lte.git',
  documentation: 'README.md'
});


Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');

  api.use([
    'templating',
    'reactive-var'
  ], 'client');

  api.addFiles([
    'admin-lte.html',
    'admin-lte.js'
  ], 'client');

  api.addFiles([
    'css/AdminLTE.css',
    'css/_all-skins.css',
  ], 'client');
});
