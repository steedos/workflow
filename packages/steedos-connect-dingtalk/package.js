Package.describe({
  summary: "connect steedos accounts with dingtalk",
  "version": "0.0.1",
  "git": "https://github.com/steedos/connect-dingtalk",
  "name": "steedos:connect-dingtalk"
});

Package.onUse(function(api) {
  api.use('ecmascript');
  api.versionsFrom("METEOR@1.0.3");
  api.use('accounts-base', ['client', 'server']);
  api.imply('accounts-base', ['client', 'server']);
  api.use('accounts-oauth', ['client', 'server']);
  api.use('simple:json-routes@2.1.0');
  api.use('coffeescript');
  api.use('kadira:flow-router@2.10.1');


  api.use('oauth', ['client', 'server']);
  api.use('oauth2', ['client', 'server']);
  api.use('http', ['server']);
  api.use('templating', 'client');
  api.use('random', 'client');
  api.use('underscore', 'server');
  api.use('service-configuration', ['client', 'server']);

  api.addFiles('checkNpm.js', 'server');

  api.addFiles('dt.js', ['client', 'server']);

  api.addFiles('dt_client.js', 'client');

  api.addFiles('client/lib/dingtalk_manager.js', 'client');
  api.addFiles('client/router.js', 'client');
  api.addFiles('client/jsapi.js', 'client');

  api.addFiles('dt_corp_api.js', 'server');
  api.addFiles('dt_server.coffee', 'server');
  api.addFiles('server_callback.js', 'server');
  api.addFiles('dt_api.coffee', 'server');
  api.addFiles('schedule.js', 'server');

  api.addFiles('methods/dt_sso.js', 'server');

  api.export('Dingtalk');

});