Package.describe({
  git: 'https://github.com/CollectionFS/Meteor-cfs-upload-ddp.git',
  name: 'steedos:cfs-upload-ddp',
  version: '0.0.17',
  summary: 'CollectionFS, DDP File Upload'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');

  api.use([
    //CFS packages
    'steedos:cfs-base-package',
    'steedos:cfs-tempstore',
    'steedos:cfs-file',
    'steedos:cfs-ejson-file',
    //Core packages
    'deps',
    'check',
    'livedata',
    'mongo-livedata',
    'ejson',
    //Other packages
    'steedos:cfs-power-queue',
    'steedos:cfs-reactive-list'
    ]);

  api.addFiles([
    'upload-ddp-client.js'
    ], 'client');

  api.addFiles([
    'upload-ddp-server.js'
    ], 'server');
});

// Package.on_test(function (api) {
//   api.use('collectionfs');
//   api.use('test-helpers', 'server');
//   api.use(['tinytest', 'underscore', 'ejson', 'ordered-dict',
//    'random', 'deps']);

//   api.addFiles('tests/server-tests.js', 'server');
//   api.addFiles('tests/client-tests.js', 'client');
// });
