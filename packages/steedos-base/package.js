Package.describe({
  name: 'steedos:base',
  version: '0.0.6',
  summary: 'Steedos libraries',
  git: 'https://github.com/steedos/platform/packages/steedos-theme'
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.3');

  api.use('session');
  api.use('coffeescript');
  api.use('ecmascript');
  api.use('blaze-html-templates');
  api.use('underscore');
  api.use('reactive-var');
  api.use('tracker');

  api.use('flemay:less-autoprefixer@1.2.0');
  api.use('kadira:flow-router@2.10.1');
  api.use('meteorhacks:subs-manager@1.6.4');

  api.use('tap:i18n@1.8.2');

  api.addFiles([
    'lib/core.coffee',
    'lib/tap-i18n.coffee',
    'client/core.coffee',
    'client/locale.coffee',
    'client/api.coffee',
    'client/helpers.coffee',
    'client/layout/main.html',
    'client/layout/main.less',
    'client/layout/main.coffee',
    'client/layout/layout.html',
    'client/layout/layout.less',
    'client/layout/header.html',
    'client/layout/header.less',
    'client/layout/sidebar.html',
  ], "client");

  api.export('Steedos');

});

Package.onTest(function(api) {

});