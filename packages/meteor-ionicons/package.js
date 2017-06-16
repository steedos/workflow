Package.describe({
  name: 'steedos:ionicons',
  summary: "Ionic's Ionicons library bundled for Meteor.",
  version: '0.1.7',
  git: 'https://github.com/steedos/apps/tree/master/packages/meteor-ionicons'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');

  api.addAssets([
    'fonts/ionicons.eot',
    'fonts/ionicons.svg',
    'fonts/ionicons.ttf',
    'fonts/ionicons.woff'
  ], 'client');

  api.addFiles('stylesheets/ionicons.css', 'client');
});
