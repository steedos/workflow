Package.describe({
  summary: "connect steedos accounts with dingtalk",
  "version": "0.0.1",
  "name": "steedos:connect-qiyeweixin"
});

Npm.depends({
  "wechat-crypto": "0.0.2",
  "request": "2.65.0",
  'node-schedule': '1.1.1'
});

Package.onUse(function(api) {
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

  api.addFiles('server_callback.coffee', 'server');
  api.addFiles('qywx.coffee', ['client', 'server']);

  api.export('Qiyeweixin');
});