Package.describe({
  name: 'steedos:base',
  version: '0.0.11',
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

  api.use('accounts-base');
  api.use('useraccounts:bootstrap@1.14.2');
  api.use('useraccounts:core@1.14.2');
  api.use('useraccounts:flow-routing@1.14.2');
  api.use('softwarerero:accounts-t9n@1.3.3');

  api.use('flemay:less-autoprefixer@1.2.0');
  api.use('kadira:flow-router@2.10.1');
  api.use('meteorhacks:subs-manager@1.6.4');

  api.use('momentjs:moment@2.14.1');

  api.use('tap:i18n@1.8.2');
  api.use('aldeed:simple-schema@1.5.3');
  api.use('aldeed:tabular@1.6.1');
  api.use('momentjs:moment');
  
  api.use('steedos:i18n@0.0.2');
  
  api.addFiles([
    'lib/core.coffee',
    'lib/accounts.coffee',
    'lib/tap-i18n.coffee']);

  api.addFiles([
    'client/core.coffee',
    'client/api.coffee',
    'client/helpers.coffee',
    'client/router.coffee',
    'client/layout/main.html',
    'client/layout/main.less',
    'client/layout/main.coffee',
    'client/layout/layout.html',
    'client/layout/layout.less',
    'client/layout/header.html',
    'client/layout/header.less',
    'client/layout/sidebar.html',
  ], "client");

  api.addFiles('client/layout/login_layout.html', "client");
  api.addFiles('client/layout/login_layout.coffee', "client");
  api.addFiles('client/layout/login_layout.less', "client");

  api.export('Steedos');
});

Package.onTest(function(api) {

});