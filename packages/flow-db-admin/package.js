Package.describe({
  name: 'sach:flow-db-admin',
  version: '1.1.5',
  // Brief, one-line summary of the package.
  summary: 'Meteor Database Admin package for use with Flow Router',
  // URL to the Git repository containing the source code for this package.
  git: 'https://github.com/sachinbhutani/flow-db-admin',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  both = ['client','server']

  api.use(
    [
    'coffeescript',
    'underscore',
    'reactive-var',
    'meteorhacks:unblock@1.1.0',
    'kadira:flow-router@2.6.2',
    'kadira:blaze-layout@2.1.0',
    'zimme:active-route@2.3.2',
    'reywood:publish-composite@1.4.2',
    'aldeed:collection2@2.5.0',
    'aldeed:autoform@5.7.1',
    'aldeed:template-extension@3.4.3',
    'alanning:roles@1.2.13',
    'raix:handlebar-helpers@0.2.5',
    'momentjs:moment@2.10.6',
    'aldeed:tabular@1.6.1',
    'steedos:adminlte',
    'check',
    'ecmascript'
    ],
    both);


  api.use(['less@1.0.0 || 2.5.0','session','jquery','templating'],'client');

  api.use(['email'],'server');

  api.use('universe:i18n@1.13.0');
  tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json'];
  api.addFiles(tapi18nFiles, ['client', 'server']);

  api.add_files([
    'lib/both/AdminDashboard.coffee',
    'lib/both/routes.js',
    'lib/both/utils.coffee',
    'lib/both/startup.coffee',
    'lib/both/collections.coffee'
    ], both);

  api.add_files([
    'lib/client/html/admin_templates.html',
    'lib/client/html/admin_widgets.html',
    'lib/client/html/fadmin_layouts.html',
    'lib/client/html/admin_sidebar.html',
    'lib/client/html/admin_header.html',
    'lib/client/js/admin_layout.js',
    'lib/client/js/helpers.coffee',
    'lib/client/js/templates.coffee',
    'lib/client/js/events.coffee',
    'lib/client/js/slim_scroll.js',
    'lib/client/js/autoForm.coffee',
    'lib/client/css/admin-custom.less'
    ], 'client');

  api.add_files([
    'lib/server/publish.coffee',
    'lib/server/methods.coffee'
    ], 'server');

  //api.addAssets(['lib/client/css/admin-custom.css'],'client');
  api.export('AdminDashboard',both)
  // api.export('TAPi18n');

});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('sach:flow-db-admin');
  api.addFiles('flow-db-admin-tests.js');
});
