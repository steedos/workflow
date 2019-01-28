Package.describe({
  summary: "connect steedos accounts with bqq",
  "version": "0.0.1",
  "git": "https://github.com/steedos/connect-bqq",
  "name": "steedos:connect-bqq"
});

Package.onUse(function(api) {
  api.use('ecmascript');
  api.versionsFrom("METEOR@1.0.3");
  api.use('accounts-base', ['client', 'server']);
  api.imply('accounts-base', ['client', 'server']);
  api.use('accounts-oauth', ['client', 'server']);
  api.use('simple:json-routes@2.1.0');
  api.use('coffeescript');
  api.use('steedos:api');

  api.addFiles('checkNpm.js', 'server');

  api.use('oauth', ['client', 'server']);
  api.use('oauth2', ['client', 'server']);
  api.use('http', ['server']);
  api.use('templating', 'client');
  api.use('random', 'client');
  api.use('underscore', 'server');
  api.use('service-configuration', ['client', 'server']);

  api.addFiles('qq_client.js', 'client');
  api.addFiles('qq_server.js', 'server');
  api.addFiles('company_token.js', 'server');
  api.addFiles('bqq_api.coffee', 'server');
  api.addFiles("qq.js");
  api.addFiles('schedule.js', 'server');

  api.export('BQQ');


});
