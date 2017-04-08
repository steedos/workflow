Package.describe({
  name: 'steedos:adminlte',
  version: '2.3.11_4',
  summary: 'adminlte package',
  git: ''
});


Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.3');

  api.use('coffeescript');
  api.use('ecmascript');

  api.use('twbs:bootstrap@3.3.6');

  api.addFiles('js/jquery.slimscroll.js', "client");
  api.addFiles('js/app.js', "client");
  api.addFiles('css/AdminLTE.css', "client");
  api.addFiles('css/skins/skin-blue.css', "client");

});

Package.onTest(function(api) {

});